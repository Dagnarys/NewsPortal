import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_portal/models/model_categories.dart';

class CategoriesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Category>> getCategories() {
    return _firestore.collection('categories').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    });
  }

  Future<void> addCategory(String name) async {
    try {
      await _firestore.collection('categories').add({
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding category: $e');
    }
  }
  Future<Category?> getCategory(String categoryId) async {
    if (categoryId.isEmpty) return null; // Если categoryId пустой, возвращаем null
    try {
      final categoryDoc =
          await FirebaseFirestore.instance.collection('categories').doc(categoryId).get();
      if (categoryDoc.exists) {
        return Category.fromFirestore(categoryDoc);
      }
      return null; // Если категория не найдена
    } catch (e) {
      print('Ошибка при загрузке категории: $e');
      return null;
    }
  }
}
