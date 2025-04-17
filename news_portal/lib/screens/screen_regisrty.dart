import 'package:flutter/material.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:news_portal/screens/screen_auth.dart';

class ScreenRegistry extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserRepository _userRepository =
      UserRepository(); // Экземпляр репозитория

  Future<void> _register(BuildContext context) async {
    try {
      // Регистрация нового пользователя через репозиторий
      await _userRepository.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // Уведомляем пользователя об успешной регистрации
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Регистрация успешна!')),
      );

      // Переход на экран авторизации
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ScreenAuth()),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TopBar(),
          Expanded(child: Container()),
          Container(
            width: 353,
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
                SizedBox(height: 10,),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _register(context),
                  child: Text('Зарегистрироваться'),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          NavBar(),
        ],
      ),
    );
  }
}
