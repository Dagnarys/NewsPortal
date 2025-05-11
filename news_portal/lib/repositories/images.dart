import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImagesRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;


    // Загрузка изображения в Firebase Storage
  Future<String> uploadImage(File imageFile, String userId) async {
    try {
      print('Создаем ссылку на Firebase Storage...');
      final Reference storageRef =
          _storage.ref().child('profile_images/$userId.jpg');

      print('Начинаем загрузку файла...');
      await storageRef.putFile(imageFile);

      print('Получаем URL загруженного файла...');
      final String downloadUrl = await storageRef.getDownloadURL();
      print('URL загруженного файла: $downloadUrl');

      return downloadUrl;
    } catch (e) {
      print('Ошибка загрузки изображения: $e');
      throw Exception('Ошибка загрузки изображения: $e');
    }
  }
  //загрузка всех изображений в firebasestorage
  Future<List<String>> uploadImages(List<XFile> images) async {
    List<String> imageUrls = [];

    for (final image in images) {
      try {
        // Генерируем уникальное имя файла
        final fileName = '${DateTime.now().millisecondsSinceEpoch}-${image.name}';
        final ref = _storage.ref().child('news_images/$fileName');

        // Загружаем изображение в Storage
        await ref.putFile(File(image.path));

        // Получаем URL-ссылку
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      } catch (e) {
        print('Ошибка при загрузке изображения: $e');
        continue;
      }
    }

    return imageUrls;
  }
  Future<String> uploadImageAdd(XFile image) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}-${image.name}';
    final ref = _storage.ref().child('news_images/$fileName');

    await ref.putFile(File(image.path));
    return await ref.getDownloadURL();
  }
}