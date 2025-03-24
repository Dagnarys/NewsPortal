import 'package:cloud_firestore/cloud_firestore.dart';

// models/model_categories.dart
class Category {
  final String id; // Добавляем ID категории
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      id: doc.id, // ID документа Firestore
      name: data['name'] ?? 'Unknown',
    );
  }
}
