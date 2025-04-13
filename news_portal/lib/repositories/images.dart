import 'package:cloud_firestore/cloud_firestore.dart';

class ImagesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Метод для получения URL изображения по его ID
  Future<String> getImageUrl(String imageId) async {
    try {
      final doc = await _firestore.collection('images').doc(imageId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return data['image'] ?? ''; // Возвращаем URL из поля 'url'
      } else {
        throw Exception('Изображение с ID $imageId не найдено');
      }
    } catch (e) {
      print('Ошибка при получении URL изображения: $e');
      return '';
    }
  }
}