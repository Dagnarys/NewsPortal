import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_portal/models/model_news.dart';

class NewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Метод для получения потока новостей с возможностью фильтрации по categoryId
  Stream<List<News>> getNewsStream({String? categoryId}) {
    Query<Map<String, dynamic>> query = _firestore.collection('news');
    if (categoryId != null) {
      query = query.where('id_category', isEqualTo: categoryId); // Фильтрация по категории
    }
    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => News.fromFirestore(doc)).toList();
    });
  }
  // Метод для получения новости по id
  Future<News> getNewsById(String id) async {
    final doc = await FirebaseFirestore.instance.collection('news').doc(id).get();
    if (doc.exists) {
      return News.fromFirestore(doc);
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