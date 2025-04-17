import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:news_portal/screens/screen_news_main.dart';
import 'package:news_portal/screens/screen_regisrty.dart';
import 'package:provider/provider.dart';

class ScreenAuth extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserRepository _userRepository =
      UserRepository(); // Экземпляр репозитория

  Future<void> _signIn(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      // Авторизация через репозиторий
      final UserCredential userCredential =
          await _userRepository.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Получение роли пользователя
      final role = await _userRepository.getUserRole(userCredential.user!.uid);
      userProvider.setRole(role ?? 'user'); // Устанавливаем роль

      // Переход на главный экран
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MainScreen()),
      );
    } catch (e) {
      // Обработка ошибок
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Верхняя панель
          TopBar(),

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
                                borderSide: BorderSide(width:1, color:  AppColors.primaryColor,style: BorderStyle.solid)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width:1, color:  AppColors.primaryColor,style: BorderStyle.solid)
                              ),
                            ),
                            
                          ),
                        
                        Expanded(child: Container()),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Пароль',
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width:1, color:  AppColors.primaryColor,style: BorderStyle.solid)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width:1, color:  AppColors.primaryColor,style: BorderStyle.solid)
                              ),
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
