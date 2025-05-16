import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:ru_phone_formatter/ru_phone_formatter.dart';

class ScreenRegistry extends StatefulWidget {
  @override
  State<ScreenRegistry> createState() => _ScreenRegistryState();
}

class _ScreenRegistryState extends State<ScreenRegistry> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      context.go('/',extra: {'categoryId':null,'searchQuery':value.toLowerCase()});
    }
  }

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _surnameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();

  final maskFormatter = RuPhoneInputFormatter();

  final UserRepository _userRepository = UserRepository();
  // Экземпляр репозитория
  Future<void> _register(BuildContext context) async {
    try {
      // Регистрация нового пользователя через репозиторий
      await _userRepository.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _nameController.text.trim(),
        _surnameController.text.trim(),
        _phoneNumberController.text.trim(),
      );

      // Уведомляем пользователя об успешной регистрации
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Регистрация успешна!')),
      );
      context.go('/auth');
      // Переход на экран авторизации
      
    } catch (e) {
      // Обработка ошибок
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TopBar(
              searchController: _searchController,
              onSubmitted: _onSearchSubmitted,
            ),
            Text(
              'Регистрация',
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: AppFonts.nunitoFontFamily,
                  fontWeight: FontWeight.w600),
            ),
            Flexible(
                // Используем Flexible вместо Expanded
                fit: FlexFit.loose,
                child: SizedBox.shrink()),
            Container(
              width: 353,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Имя',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: AppColors.primaryColor,
                              style: BorderStyle.solid)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                              width: 1,
                              color: AppColors.primaryColor,
                              style: BorderStyle.solid)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: _surnameController,
                    decoration: InputDecoration(
                      labelText: 'Фамилия',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: AppColors.primaryColor,
                              style: BorderStyle.solid)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                              width: 1,
                              color: AppColors.primaryColor,
                              style: BorderStyle.solid)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                              width: 1,
                              color: AppColors.primaryColor,
                              style: BorderStyle.solid)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    inputFormatters: [maskFormatter],
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Номер телефона',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: AppColors.primaryColor,
                              style: BorderStyle.solid)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                              width: 1,
                              color: AppColors.primaryColor,
                              style: BorderStyle.solid)),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    obscureText: !_isPasswordVisible,
                    controller: _passwordController,
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
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                              width: 1,
                              color: AppColors.primaryColor,
                              style: BorderStyle.solid)),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                      onPressed: () => _register(context),
                      child: Container(
                        width: 254,
                        height: 56,
                        decoration: BoxDecoration(
                            gradient: AppColors.buttonGradient,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Center(
                            child: Text(
                          'Зарегистрироваться',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        )),
                      )),
                ],
              ),
            ),
          ],
        ),
        Align(
            // Позиционируем NavBar внизу экрана
            alignment: Alignment.bottomCenter,
            child: NavBar())
      ]),
    );
  }
}
