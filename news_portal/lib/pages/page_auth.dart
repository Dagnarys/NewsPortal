import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:provider/provider.dart';

class PageAuth extends StatefulWidget {
  const PageAuth({super.key});

  @override
  State<PageAuth> createState() => _ScreenAuthState();
}

class _ScreenAuthState extends State<PageAuth> {
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
      if (!mounted) return;
      // Теперь мы знаем роль пользователя
      if (userProvider.isModerator) {
        context.go('/web-news');
        
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

          // Основное содержимое
          Expanded(
            child: Center(
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
