import 'package:flutter/material.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:news_portal/screens/screen_news_main.dart';
import 'package:news_portal/screens/screen_regisrty.dart';
import 'package:provider/provider.dart';

class ScreenAuth extends StatefulWidget {
  const ScreenAuth({super.key});

  @override
  State<ScreenAuth> createState() => _ScreenAuthState();
}

class _ScreenAuthState extends State<ScreenAuth> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            searchQuery: value.toLowerCase(), // ← Передаём поисковый запрос
          ),
        ),
      );
    }
  }

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final UserRepository _userRepository = UserRepository();
  // Экземпляр репозитория
Future<void> _signIn(BuildContext context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);

  try {
    // Вход по email/password
    await _userRepository.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    // Загружаем полные данные пользователя из Firestore
    await userProvider.loadCurrentUser();

    // Теперь мы знаем роль пользователя
    if (userProvider.isModerator) {
      
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Ошибка входа: $e')),
    );
  }
}

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Верхняя панель
          TopBar(
            searchController: _searchController,
            onSubmitted: _onSearchSubmitted,
          ),

          // Основное содержимое
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Авторизация',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: 340,
                    height: 140,
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.primaryColor,
                                    style: BorderStyle.solid)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.primaryColor,
                                    style: BorderStyle.solid)),
                          ),
                        ),
                        Expanded(child: Container()),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            labelText: 'Пароль',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.primaryColor,
                                    style: BorderStyle.solid)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: AppColors.primaryColor,
                                    style: BorderStyle.solid)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () => _signIn(context),
                      child: Container(
                        width: 254,
                        height: 56,
                        decoration: BoxDecoration(
                            gradient: AppColors.buttonGradient,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                            child: Text(
                          'Войти',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        )),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenRegistry()));
                      },
                      child: Container(
                        width: 158,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Нет аккаунта?',
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Создать',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ),

          // Нижняя панель навигации
          NavBar(),
        ],
      ),
    );
  }
}
