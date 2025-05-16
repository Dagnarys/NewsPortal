import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_portal/components/news_stream.dart';
import 'package:news_portal/models/model_comment.dart';
import 'package:news_portal/models/model_news.dart';

class NewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  // Получение списка новостей с изображениями
  Stream<List<News>> getNewsStream() {
    return _firestore
        .collection('news')
        .orderBy('publishedAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => News.fromFirestore(doc)).toList());
  }

  Future<List<News>> getNewsWithImages(
      {String? categoryId, String? query}) async {
    Query firestoreQuery =
        _firestore.collection('news').orderBy('publishedAt', descending: true);

    // Фильтр по категории
    if (categoryId != null && categoryId.isNotEmpty) {
      firestoreQuery =
          firestoreQuery.where('id_category', isEqualTo: categoryId);
    }

    // Поиск по заголовкам и контенту
    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      firestoreQuery = firestoreQuery
          .where('title', isGreaterThanOrEqualTo: lowerQuery)
          .where('title', isLessThan: '$lowerQuery\uf8ff');
    }

    final snapshot = await firestoreQuery.get();

    final List<News> newsList = [];

    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;

      // Получаем изображения из подколлекции images
      final imagesSnapshot = await doc.reference.collection('images').get();
      final imageUrls = imagesSnapshot.docs
          .map((imgDoc) => imgDoc.get('image') as String)
          .toList();

      final news = News(
        id: doc.id,
        title: data['title'] ?? 'Без заголовка',
        content: data['content'] ?? 'Нет текста',
        categoryId: data['id_category'] ?? '',
        imageUrls: imageUrls,
        authorName: data['authorName'] ?? 'Неизвестный автор',
        commentCount: data['commentCount'] is int ? data['commentCount'] : 0,
        viewCount: data['viewCount'] is int ? data['viewCount'] : 0,
        publishedAt: data['publishedAt'] is Timestamp
            ? data['publishedAt']
            : Timestamp.now(),
        authorEmail: data['authorEmail'],
      );

      newsList.add(news);
    }

    return newsList;
  }

  Stream<List<News>> getPendingNewsStream() {
    return FirebaseFirestore.instance
        .collection('news')
        .where('status', isEqualTo: 'pending')
        .orderBy('publishedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => News.fromFirestore(doc)).toList();
    });
  }

  Stream<List<News>> getNewsStreamWithImages({
    String? categoryId,
    String? searchQuery,
    SortOption sortOption = SortOption.newest,
    bool isAscending = false,
  }) {
    Query baseQuery =
        _firestore.collection('news').where('status', isEqualTo: 'approved');

    // Фильтрация по категории
    if (categoryId != null && categoryId.isNotEmpty) {
      baseQuery = baseQuery.where('id_category', isEqualTo: categoryId);
    }

    // Сортировка на стороне сервера
    switch (sortOption) {
      case SortOption.newest:
        baseQuery = baseQuery.orderBy('publishedAt', descending: true);
        break;
      case SortOption.oldest:
        baseQuery = baseQuery.orderBy('publishedAt', descending: false);
        break;
      default:
        // Для просмотров используем клиентскую сортировку
        baseQuery = baseQuery.orderBy('publishedAt', descending: true);
    }

    return baseQuery.snapshots().asyncMap((snapshot) async {
      final List<News> newsList = [];

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Загружаем изображения
        final imagesSnapshot = await doc.reference.collection('images').get();
        final imageUrls = imagesSnapshot.docs
            .map((imgDoc) => imgDoc.get('image') as String)
            .toList();

        // Создаем объект новости
        newsList.add(News(
          id: doc.id,
          title: data['title'] ?? 'Без заголовка',
          content: data['content'] ?? 'Нет текста',
          categoryId: data['id_category'] ?? '',
          imageUrls: imageUrls,
          authorName: data['authorName'] ?? 'Неизвестный автор',
          commentCount: data['commentCount'] is int ? data['commentCount'] : 0,
          viewCount: data['viewCount'] is int ? data['viewCount'] : 0,
          publishedAt: data['publishedAt'] is Timestamp
              ? data['publishedAt']
              : Timestamp.now(),
          authorEmail: data['authorEmail'] ?? '',
          status: data['status'] ?? 'pending',
        ));
      }

      // Клиентская сортировка по просмотрам
      if (sortOption == SortOption.mostViews ||
          sortOption == SortOption.leastViews) {
        newsList.sort((a, b) {
          if (sortOption == SortOption.mostViews) {
            return isAscending
                ? a.viewCount.compareTo(b.viewCount)
                : b.viewCount.compareTo(a.viewCount);
          } else {
            return isAscending
                ? a.viewCount.compareTo(b.viewCount)
                : b.viewCount.compareTo(a.viewCount);
          }
        });
      }

      return newsList;
    }).handleError((error) {
      print("Ошибка загрузки новостей: $error");
      return [];
    });
  }

  // Метод для получения новости по id
  Future<News> getNewsById(String id) async {
    final doc = await _firestore.collection('news').doc(id).get();
    if (!doc.exists) throw Exception('Новость с ID $id не найдена');

    final news = News.fromFirestore(doc);

    // Получаем все изображения из подколлекции
    final imagesSnapshot =
        await _firestore.collection('news').doc(id).collection('images').get();

    final imageUrls = imagesSnapshot.docs
        .map((doc) => (doc.data())['image'] as String)
        .whereType<String>()
        .toList();

    print("Загружено изображений для новости: ${imageUrls.length}");

    return News(
      id: news.id,
      title: news.title,
      content: news.content,
      categoryId: news.categoryId,
      imageUrls: imageUrls,

      authorName: news.authorName, // ← только имя
      commentCount: news.commentCount, // ← количество комментариев
      viewCount: news.viewCount, // ← количество просмотров
      publishedAt: news.publishedAt, // ← дата публикации
      authorEmail: news.authorEmail,
    );
  }

  // Получить поток комментариев по ID новости
  Stream<List<Comment>> getCommentsStream(String newsId) {
    print("Подписываемся на комментарии для новости: $newsId");

    return _firestore
        .collection('news')
        .doc(newsId)
        .collection('comments')
        .orderBy('created_at', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      print("Получен новый снимок, количество документов: ${snapshot.docs}");

      try {
        List<Comment> comments = [];

        for (var doc in snapshot.docs) {
          print("Обрабатываем документ: ${doc.id}");
          if (!doc.exists) {
            print("Документ не существует: ${doc.id}");
            continue;
          }

          final data = doc.data();

          print("Данные документа (${doc.id}): $data");

          final comment = Comment.fromFirestore(doc);
          comments.add(comment);
        }

        print("Комментарии готовы. Всего: ${comments.length}");
        return comments;
      } catch (e, stackTrace) {
        print("Ошибка при обработке комментариев: $e");
        print("Stack trace: $stackTrace");
        return [];
      }
    });
  }

  Future<void> addCommentToNews(String newsId, Comment comment) async {
    try {
      await _firestore
          .collection('news')
          .doc(newsId)
          .collection('comments')
          .add(comment.toFirestore());
    } catch (e) {
      print("Ошибка при добавлении комментария: $e");
    }
  }

  // Метод для обновления данных
  Future<void> refreshData() async {
    final CollectionReference newsRef =
        FirebaseFirestore.instance.collection('news');
    final QuerySnapshot snapshot = await newsRef.limit(10).get();
  }

  Stream<int> getCommentCount(String newsId) {
    return FirebaseFirestore.instance
        .collection('news')
        .doc(newsId)
        .collection('comments')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  void incrementViewCount(String newsId) async {
    final newsRef = FirebaseFirestore.instance.collection('news').doc(newsId);
    await newsRef.update({'viewCount': FieldValue.increment(1)});
  }

  Future<void> deleteComment(String newsId, String commentId) async {
    await FirebaseFirestore.instance
        .collection('news')
        .doc(newsId)
        .collection('comments')
        .doc(commentId)
        .delete();
  }

  Future<void> updateNewsStatus(String newsId, String newStatus) async {
    final newsRef = FirebaseFirestore.instance.collection('news').doc(newsId);

    try {
      await newsRef.update({'status': newStatus});
      print('Статус новости $newsId обновлен на $newStatus');
    } catch (e) {
      print('Ошибка обновления статуса: $e');
      rethrow;
    }
  }

  /// Обновляет новость в Firestore, включая основные данные и изображения
  Future<void> updateNews(
      News news, List<XFile> newImages, List<String> existingImageUrls) async {
    final DocumentReference newsRef =
        _firestore.collection('news').doc(news.id);

    try {
      // 1. Обновите основные данные новости
      await newsRef.update({
        'title': news.title,
        'content': news.content,
        'id_category': news.categoryId,
        'authorName': news.authorName,
        'authorEmail': news.authorEmail,
        'publishedAt': news.publishedAt,
        'status': news.status,
      });

      // 2. Удалите только те изображения, которые были удалены пользователем
      final QuerySnapshot existingImagesSnapshot =
          await newsRef.collection('images').get();
      for (var doc in existingImagesSnapshot.docs) {
        final String imageUrl = doc.get('image');
        if (!existingImageUrls.contains(imageUrl)) {
          // Удаляем изображение из Storage, если оно не находится в списке оставшихся
          final Uri uri = Uri.parse(imageUrl);
          final String imagePath = uri.path;
          try {
            await _storage.ref().child(imagePath).delete();
          } catch (e) {
            if (e is FirebaseException && e.code != 'object-not-found') {
              print('Ошибка при удалении изображения из Storage: $e');
            }
          }
          await doc.reference.delete(); // Удаляем запись из Firestore
        }
      }

      // 3. Загрузите новые изображения в Storage и добавьте их в Firestore
      for (int i = 0; i < newImages.length; i++) {
        final String imageUrl = await uploadImageToStorage(
            newImages[i], news.id, existingImageUrls.length + i);
        await newsRef.collection('images').add({'image': imageUrl});
      }

      print('Новость и изображения успешно обновлены');
    } catch (e) {
      print('Ошибка обновления новости: $e');
      throw e;
    }
  }

  Future<String> uploadImageToStorage(
      XFile imageFile, String newsId, int index) async {
    final Reference reference =
        _storage.ref().child('news/$newsId/image_$index.jpg');

    final UploadTask uploadTask = reference.putData(
      await imageFile.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    return await taskSnapshot.ref.getDownloadURL();
  }
}
