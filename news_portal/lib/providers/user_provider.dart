import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:news_portal/screens/screen_news_main.dart';

class UserProvider with ChangeNotifier {

  final UserRepository _userRepository = UserRepository();
  String? _role;
  String? _userId;
  String? get role => _role;

  bool get isGuest => _role == null;
  bool get isUser => _role == 'user';
  bool get isModerator => _role == 'moderator';

  String? get userId => _userId;

  void setRole(String newRole) {
    _role = newRole;
    notifyListeners();
  }

  // Метод для установки userId (например, при входе в систему)
  void setUserId(String id) {
    _userId = id;
    notifyListeners(); // Уведомляем слушателей об изменении состояния
  }
  void clearRole() {
    _role = null;
    notifyListeners();
  }
    Future<void> loadCurrentUser() async {
    try {
      final userData = await _userRepository.getCurrentUserData();
      if (userData != null) {
        _userId = FirebaseAuth.instance.currentUser!.uid; // Устанавливаем userId
        notifyListeners();
      }
    } catch (e) {
      print('Ошибка загрузки данных пользователя: $e');
    }
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