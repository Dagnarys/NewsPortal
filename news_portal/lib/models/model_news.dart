import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_portal/repositories/categories.dart';

class News {
  final String id;
  final String title;
  final String content;
  final String categoryId;
  final List<String> imageUrls; // ← здесь список URL'ов
  final String authorName;
  final String authorEmail;
  final int commentCount;
  final int viewCount;
  final Timestamp publishedAt;
  final String status;

  News({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryId,
    required this.imageUrls,
    required this.authorName,
    this.commentCount = 0,
    this.viewCount = 0,
    required this.publishedAt,
    required this.authorEmail,
    this.status = 'pending',
  });

  factory News.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final imageList = <String>[];
    
    return News(
      id: doc.id,
      title: data['title'] ?? 'Без заголовка',
      content: data['content'] ?? 'Нет текста',
      categoryId: data['id_category'] ?? '',
      authorEmail: data['authorEmail']??'',
      imageUrls: imageList, // ← получаем напрямую
      authorName: data['authorName'] ?? 'Неизвестный автор',
      commentCount: data['commentCount'] is int ? data['commentCount'] : 0,
      viewCount: data['viewCount'] is int ? data['viewCount'] : 0,
      publishedAt: data['publishedAt'] is Timestamp
          ? data['publishedAt']
          : Timestamp.now(),
      status: data['status']??'pending',
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
