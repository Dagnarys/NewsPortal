import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Вход пользователя по email и паролю
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Ошибка входа: $e');
    }
  }

  // Регистрация нового пользователя
  Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      // Регистрация пользователя через Firebase Authentication
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Сохранение данных пользователя в Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
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
  
}