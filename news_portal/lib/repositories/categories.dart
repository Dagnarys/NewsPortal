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
    await _firestore.collection('categories').add({
      'name': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  
}
