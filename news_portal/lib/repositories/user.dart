import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Вход пользователя по email и паролю
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Получаем ID пользователя
    } catch (e) {
      throw Exception('Ошибка входа: $e');
    }
  }

  // Регистрация нового пользователя
  Future<void> registerWithEmailAndPassword(String email, String password,
      String name, String surname, String phoneNumber) async {
    try {
      // Регистрация пользователя через Firebase Authentication
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Сохранение данных пользователя в Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'name': name,
        'surname': surname,
        'phone_number': phoneNumber,
        'role': 'user', // По умолчанию роль 'user'
      });
    } catch (e) {
      throw Exception('Ошибка регистрации: $e');
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Ошибка получения данных пользователя: $e');
    }
  }

  // Выход из системы
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Ошибка выхода: $e');
    }
  }

  // Получение роли пользователя из Firestore
  Future<String?> getUserRole(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data()!['role'] as String?;
      }
      return null;
    } catch (e) {
      throw Exception('Ошибка получения роли: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserDetails(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (doc.exists) {
        final userData = doc.data() as Map<String, dynamic>;

        return userData;
      } else {
        return null; // Если пользователь не найден
      }
    } catch (e) {
      throw Exception('Ошибка при получении данных пользователя: $e');
    }
  }

  Future<void> updateUserDetails(
    String userId,
    String name,
    String surname,
    String email,
    String phoneNumber,
    String? imageUrl,
  ) async {
    try {
      print('Обновляем данные пользователя в Firestore...');
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'surname': surname,
        'email': email,
        'phoneNumber': phoneNumber,
        if (imageUrl != null) 'imageUrl': imageUrl, // Добавляем или обновляем поле imageUrl
      }, SetOptions(merge: true)); // Используем merge, чтобы не перезаписывать все поля
      print('Данные пользователя успешно обновлены');
     final updatedUserData = await _firestore.collection('users').doc(userId).get();
    print('Обновленные данные пользователя: ${updatedUserData.data()}');
  } catch (e) {
    print('Ошибка обновления данных пользователя: $e');
    throw Exception('Ошибка обновления данных пользователя: $e');
  }
  }
  

  // Загрузка изображения в Firebase Storage
  Future<String> uploadImage(File imageFile, String userId) async {
  try {
    print('Создаем ссылку на Firebase Storage...');
    final Reference storageRef = _storage.ref().child('profile_images/$userId.jpg');

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

  // Обновление ссылки на изображение в Firestore
  Future<void> updateProfileImage(String userId, String imageUrl) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'imageUrl': imageUrl,
      });
    } catch (e) {
      throw Exception('Ошибка обновления изображения: $e');
    }
  }

}
