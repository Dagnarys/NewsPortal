import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/repositories/images.dart';

class NewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagesRepository _imagesRepo = ImagesRepository();

  // Метод для получения потока новостей с возможностью фильтрации по categoryId
  Stream<List<News>> getNewsStream({String? categoryId}) {
    Query<Map<String, dynamic>> query = _firestore.collection('news');
    if (categoryId != null) {
      query = query.where('id_category', isEqualTo: categoryId); // Фильтрация по категории
    }
    return query.snapshots().asyncMap((snapshot) async {
      final newsList = <News>[];
      for (final doc in snapshot.docs) {
        final news = News.fromFirestore(doc);
        // Получаем URL изображения для каждой новости
        final imageUrl = await _imagesRepo.getImageUrl(news.imageId);
        news.imageUrl = imageUrl; // Добавляем URL в модель
        newsList.add(news);
      }
      return newsList;
    });
  }

  // Метод для получения новости по id
  Future<News> getNewsById(String id) async {
    final doc = await _firestore.collection('news').doc(id).get();
    if (doc.exists) {
      final news = News.fromFirestore(doc);
      // Получаем URL изображения для новости
      final imageUrl = await _imagesRepo.getImageUrl(news.imageId);
      news.imageUrl = imageUrl; // Добавляем URL в модель
      return news;
    } else {
      throw Exception('Новость с ID $id не найдена');
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