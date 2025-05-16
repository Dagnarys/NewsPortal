import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/models/model_user.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart';

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
  bool get isAuthenticated => _currentUser?.role == 'moderator';
  Future<void> loadCurrentUser() async {
    try {
      final firebaseUser = auth.FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        // Попробуем загрузить из кэша
        await loadUserFromPrefs();
        notifyListeners();
        return;
      }

      // Загружаем из Firestore
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
        await saveUserToPrefs(); // Сохраняем в кэш
      } else {
        // Дефолтный пользователь
        _currentUser = User(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: '',
          surname: '',
          role: 'user',
          imageUrl: null,
        );
        await saveUserToPrefs();
      }

      notifyListeners();
    } catch (e) {
      print('Ошибка загрузки пользователя: $e');
      await loadUserFromPrefs(); // Если всё сломалось — загружаем из кэша
      notifyListeners();
    }
  }

  // Выход из аккаунта
  Future<void> signOut(BuildContext context) async {
    try {
      await _userRepository.signOut();
      await clearUserFromPrefs(); // Чистим кэш
      _currentUser = null;
      notifyListeners();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go('/');
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка выхода: $e')),
      );
    }
  }
  Future<void> signOutWeb(BuildContext context) async {
    try {
      await _userRepository.signOut();
      await clearUserFromPrefs();
      _currentUser = null;
      notifyListeners();

      // Сбрасываем историю браузера
      if (context.mounted) {
        context.pushReplacementNamed('web-auth');
      }
    } catch (e) {
      // Обработка ошибок
    }
  }
  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> saveUserToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (_currentUser != null) {
      prefs.setString('user_id', _currentUser!.id);
      prefs.setString('user_email', _currentUser!.email);
      prefs.setString('user_name', _currentUser!.name);
      prefs.setString('user_surname', _currentUser!.surname);
      prefs.setString('user_role', _currentUser!.role);
      prefs.setString('user_image_url', _currentUser!.imageUrl ?? '');
    }
  }

  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    if (userId == null) return;

    try {
      final userData = await UserRepository().getUserDetails(userId);
      if (userData != null) {
        _currentUser = User(
          id: userId,
          email: userData['email'] ?? '',
          name: userData['name'] ?? '',
          surname: userData['surname'] ?? '',
          role: userData['role'] ?? 'user',
          imageUrl: userData['imageUrl'],
        );
        notifyListeners();
      }
    } catch (e) {
      print("Ошибка загрузки из кэша: $e");
    }
  }

  Future<void> clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('user_id');
    prefs.remove('user_email');
    prefs.remove('user_name');
    prefs.remove('user_surname');
    prefs.remove('user_role');
    prefs.remove('user_image_url');
  }
}
