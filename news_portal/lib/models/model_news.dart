  import 'package:cloud_firestore/cloud_firestore.dart';

  // Модель для новости
  class News {
    final String id;
    final String title;
    final String content;

    News({
      required this.id,
      required this.title,
      required this.content,
    });

    factory News.fromFirestore(DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      return News(
        id: doc.id,
        title: data['title'] ?? 'No Title',
        content: data['content'] ?? 'No Content',
      );
    }
  }