// lib/models/comment.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String newsId;
  final String userId;
  final String text;
  final Timestamp createdAt;
  final String userName; // ← новое поле
  final String userSurname; // ← новое поле

  Comment({
    required this.id,
    required this.newsId,
    required this.userId,
    required this.text,
    required this.createdAt,
    required this.userSurname,
    required this.userName,
  });

  // Конструктор для создания объекта Comment из данных Firestore
  factory Comment.fromFirestore(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Comment(
      id: snapshot.id,
      newsId: data['news_id'] ?? '',
      userId: data['user_id'] ?? '',
      text: data['text'] ?? '',
      createdAt: data['created_at'] ?? Timestamp.now(),
      userName: data['user_name'] ?? '',
      userSurname: data['user_surname'] ?? '',
    );
  }

  // Метод для преобразования объекта в Map (полезно при добавлении/обновлении)
  Map<String, dynamic> toFirestore() {
    return {
      'news_id': newsId,
      'user_id': userId,
      'text': text,
      'created_at': createdAt,
      'user_name': userName,
      'user_surname': userSurname,
    };
  }
}
