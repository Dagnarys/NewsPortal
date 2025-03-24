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

  // Метод для получения категории по ID
  Future<Category?> getCategory(String id) async {
    try {
      final doc = await _firestore.collection('categories').doc(id).get();
      if (doc.exists) {
        return Category.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Ошибка при загрузке категории: $e');
      return null;
    }
  }

  // Метод для получения категории по имени
  Future<Category?> getCategoryByName(String name) async {
    try {
      final querySnapshot = await _firestore
          .collection('categories')
          .where('name', isEqualTo: name)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return Category.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Ошибка при поиске категории по имени: $e');
      return null;
    }
  }
}
