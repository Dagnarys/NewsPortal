import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_portal/repositories/categories.dart';


class News {
  final String id;
  final String title;
  final String content;
  final String categoryId;
  final List<dynamic> images; // просто пути или ID изображений

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryId,
    required this.images,
  });

  factory News.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final imageList = (data['images'] as List?)?.map((item) => item.toString()).toList() ?? [];

    return News(
      id: doc.id,
      title: data['title'] ?? 'Без заголовка',
      content: data['content'] ?? 'Нет текста',
      categoryId: data['id_category'] ?? '',
      images: imageList,
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
  // Модель для новости
// class News {
//   final String id;
//   final String title;
//   final String content;
//   final String categoryId; // Связь с категорией
 
//   final List<String> images;

//   News({
//     required this.id,
//     required this.title,
//     required this.content,
//     required this.categoryId,
//     required this.images,
//   });

//   factory News.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     final imageList = data['images'] is List ? (data['images'] as List).cast<String>() : <String>[];
//     return News(
//       id: doc.id,
//       title: data['title'] ?? 'No Title',
//       content: data['content'] ?? 'No Content',
//       categoryId: data['id_category'] ?? '', // Получаем categoryId из Firestore
//       images: imageList, // Получаем imageId из Firestore
//     );
//   }



//   // Метод для получения URL изображения через ImagesRepository
//   Future<String> getImageUrl(ImagesRepository imagesRepo) async {
//     if (images.isEmpty) return ''; // Если нет imageId, возвращаем пустую строку
//     try {
//       final imageUrl = await imagesRepo.getImageUrl(images[0]);
//       return imageUrl;
//     } catch (e) {
//       print('Ошибка при получении URL изображения: $e');
//       return '';
//     }
//   }
// }