import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_portal/models/model_comment.dart';
import 'package:news_portal/models/model_news.dart';

class NewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Метод для получения потока новостей с возможностью фильтрации по categoryId
  Stream<List<News>> getNewsStream({String? categoryId}) {
    Query<Map<String, dynamic>> query = _firestore.collection('news');
    if (categoryId != null) {
      query = query.where('id_category', isEqualTo: categoryId);
    }

    return query.snapshots().asyncMap((snapshot) async {
      final newsList = <News>[];

      for (final doc in snapshot.docs) {
        final news = News.fromFirestore(doc);

        // Получаем все изображения из подколлекции
        final imagesSnapshot = await _firestore
            .collection('news')
            .doc(news.id)
            .collection('images')
            .get();

        final imageUrls = imagesSnapshot.docs.map((doc) {
          final data = doc.data();
          return data['image'] as String;
        }).toList();

        print(
            "Загружено изображений для новости ${news.title}: ${imageUrls.length}");

        final updatedNews = News(
          id: news.id,
          title: news.title,
          content: news.content,
          categoryId: news.categoryId,
          images: imageUrls, // ← Теперь тут список из 3 изображений
        );

        newsList.add(updatedNews);
      }

      return newsList;
    });
  }

  // Метод для получения новости по id
  Future<News> getNewsById(String id) async {
  final doc = await _firestore.collection('news').doc(id).get();
  if (!doc.exists) throw Exception('Новость с ID $id не найдена');

  final news = News.fromFirestore(doc);

  // Получаем все изображения из подколлекции
  final imagesSnapshot = await _firestore
      .collection('news')
      .doc(id)
      .collection('images')
      .get();

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
    images: imageUrls, // ← теперь тут полный список
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
    try {
      // Здесь можно добавить логику обновления данных
      // Например, принудительно перезагрузить коллекцию из Firestore
      await _firestore.collection('news').get();
      print('Данные обновлены');
    } catch (e) {
      print('Ошибка при обновлении данных: $e');
    }
  }
}
