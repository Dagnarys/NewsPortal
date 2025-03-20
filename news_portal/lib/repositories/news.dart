import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_portal/models/model_news.dart';

class NewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<News>> getNewsStream() {
    return _firestore.collection('news').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => News.fromFirestore(doc)).toList();
    });
  }
  Future<News> getNewsById(String id) async {
    final doc = await FirebaseFirestore.instance.collection('news').doc(id).get();
    if (doc.exists) {
      return News.fromFirestore(doc);
    } else {
      throw Exception('Новость с ID $id не найдена');
    }
  }
}