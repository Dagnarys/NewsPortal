import 'dart:io';
import 'dart:typed_data';

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
        final bytes = await image.readAsBytes();
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}-${image.name}';
        final ref = _storage.ref().child('news_images').child(fileName);

        await ref.putData(bytes);
        final url = await ref.getDownloadURL();
        imageUrls.add(url);
      } catch (e) {
        print('Ошибка при загрузке изображения: $e');
      }
    }

    return imageUrls;
  }

  Future<String> uploadImageAdd(XFile image) async {
    final bytes = await image.readAsBytes();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref =
        FirebaseStorage.instance.ref().child('news_images').child(fileName);
    final uploadTask = await ref.putData(bytes);
    final url = await uploadTask.ref.getDownloadURL();
    return url;
  }
  Future<String> uploadImageMoblie({
    required Uint8List imageBytes,
    required String userId,
    required String fileName,
  }) async {
    final ref = _storage.ref().child('news_images/$userId/$fileName');
    await ref.putData(imageBytes);
    return await ref.getDownloadURL();
  }
  Future<String> uploadImageWeb({
    required Uint8List imageBytes,
    required String userId,
    required String fileName,
  }) async {
    final storage = FirebaseStorage.instance;
    final fileNameWithTimestamp =
        '${DateTime.now().millisecondsSinceEpoch}_$fileName';
    final ref = storage
        .ref()
        .child('profile_images')
        .child(userId)
        .child(fileNameWithTimestamp);

    final uploadTask = await ref.putData(
      imageBytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    
    return await uploadTask.ref.getDownloadURL();
  }
}
