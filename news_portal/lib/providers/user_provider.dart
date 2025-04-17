import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:news_portal/screens/screen_news_main.dart';

class UserProvider with ChangeNotifier {
  String? _role;

  String? get role => _role;

  bool get isGuest => _role == null;
  bool get isUser => _role == 'user';
  bool get isModerator => _role == 'moderator';

  void setRole(String newRole) {
    _role = newRole;
    notifyListeners();
  }

  void clearRole() {
    _role = null;
    notifyListeners();
  }
  Future<void> signOut(BuildContext context) async {
    final userRepository = UserRepository(); // Инициализация репозитория
    try {
      await userRepository.signOut();
      clearRole(); // Очищаем роль пользователя
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка выхода: $e')),
      );
    }
  }
}