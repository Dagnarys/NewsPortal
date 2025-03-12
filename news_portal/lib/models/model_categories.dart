import 'package:cloud_firestore/cloud_firestore.dart';

// models/model_categories.dart
class Category {
  final String name;

  Category({required this.name});

  factory Category.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Category(
      name: data['name'] ?? 'Unknown',
    );
  }
}
