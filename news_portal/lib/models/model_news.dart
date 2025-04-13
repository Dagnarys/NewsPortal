import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_portal/repositories/categories.dart';
import 'package:news_portal/repositories/images.dart';

  // Модель для новости
class News {
  final String id;
  final String title;
  final String content;
  final String categoryId; // Связь с категорией
  final String imageId; // ID изображения из коллекции images
  String imageUrl; // Поле для хранения URL изображения

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryId,
    required this.imageId,
    this.imageUrl = '', // Инициализируем пустой строкой по умолчанию
  });

  factory News.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return News(
      id: doc.id,
      title: data['title'] ?? 'No Title',
      content: data['content'] ?? 'No Content',
      categoryId: data['id_category'] ?? '', // Получаем categoryId из Firestore
      imageId: data['image_url'] ?? '', // Получаем imageId из Firestore
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

  // Метод для получения URL изображения через ImagesRepository
  Future<String> getImageUrl(ImagesRepository imagesRepo) async {
    if (imageId.isEmpty) return ''; // Если нет imageId, возвращаем пустую строку
    try {
      final imageUrl = await imagesRepo.getImageUrl(imageId);
      return imageUrl;
    } catch (e) {
      print('Ошибка при получении URL изображения: $e');
      return '';
    }
  }
}