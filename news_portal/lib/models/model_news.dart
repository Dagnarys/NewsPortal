import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_portal/repositories/categories.dart';

  // Модель для новости
class News {
  final String id;
  final String title;
  final String content;
  final String categoryId; // Связь с категорией
  final String imageUrl;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryId, // Добавляем categoryId
    required this.imageUrl,
  });

  factory News.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return News(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      content: data['content'] ?? 'No Content',
      categoryId: data['id_category'] ?? '', // Получаем categoryId из Firestore
      imageUrl: data['image_url']?? '',
    );
  }
  Future<String> getCategoryName(CategoriesRepository categoryRepo) async {
    if (categoryId.isEmpty) return 'нет категории';
    try {
      final category = await categoryRepo.getCategory(categoryId);
      return category?.name ?? 'Неизвестная категория';
    } catch (e) {
      return 'Неизвестная категория';
    }
  }
}