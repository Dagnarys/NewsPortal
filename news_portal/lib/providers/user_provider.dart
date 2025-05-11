import 'package:flutter/material.dart';
import 'package:news_portal/models/model_user.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:news_portal/screens/screen_news_main.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  User? _currentUser;

  User? get user => _currentUser;
  String get userEmail => _currentUser?.email ?? '';
  String get userFirstName => _currentUser?.name ?? '';
  String get userLastName => _currentUser?.surname ?? '';
  String get userFullName => '$userFirstName $userLastName'.trim();
  String get userAvatarUrl => _currentUser?.imageUrl ?? '';
  bool get isGuest => _currentUser == null;
  bool get isUser => _currentUser?.role == 'user';
  bool get isModerator => _currentUser?.role == 'moderator';
  String? get userId => _currentUser?.id;

  Future<void> loadCurrentUser() async {
    try {
      // Получаем текущего пользователя из Firebase Auth
      final firebaseUser = auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        _currentUser = null;
        notifyListeners();
        return;
      }

      // Получаем дополнительные данные из Firestore
      final userData = await _userRepository.getUserDetails(firebaseUser.uid);
      if (userData != null) {
        _currentUser = User(
          id: firebaseUser.uid,
          email: userData['email'] ?? '',
          name: userData['name'] ?? '',
          surname: userData['surname'] ?? '',
          role: userData['role'] ?? 'user',
          imageUrl: userData['imageUrl'],
        );
      } else {
        // Если данных нет — создаём дефолтного пользователя
        _currentUser = User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: '',
          surname: '',
          role: 'user',
          imageUrl: null,
        );
      }

      notifyListeners();
    } catch (e) {
      print('Ошибка загрузки данных пользователя: $e');
      _currentUser = null;
      notifyListeners();
    }
  }

  // Выход из аккаунта
  Future<void> signOut(BuildContext context) async {
    try {
      await _userRepository.signOut();
      _currentUser = null;
      notifyListeners();

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