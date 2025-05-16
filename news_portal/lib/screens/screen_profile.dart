import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/images.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:news_portal/screens/screen_auth.dart';
import 'package:provider/provider.dart';
import 'package:news_portal/const/colors.dart';
import 'package:ru_phone_formatter/ru_phone_formatter.dart';

class ScreenProfile extends StatefulWidget {
  const ScreenProfile({super.key});

  @override
  _ScreenProfileState createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  final TextEditingController _searchController = TextEditingController();


  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
       context.go('/',extra: {'categoryId':null,'searchQuery':value.toLowerCase()});
    }
  }
  final ImagesRepository _storage = ImagesRepository();
  final UserRepository _userRepository =
      UserRepository(); // Экземпляр репозитория
  bool _isEditing = false; // Флаг для режима редактирования
  File? _selectedImage;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final maskFormatter = RuPhoneInputFormatter();

  // Метод для выбора изображения
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage =
            File(pickedFile.path); // Сохраняем выбранное изображение
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Проверяем, есть ли userId
    if (userProvider.userId == null) {
      return ScreenAuth();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userRepository.getUserDetails(
            userProvider.userId!), // Получаем данные пользователя
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Показываем индикатор загрузки
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Показываем сообщение об ошибке
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // Отображаем данные пользователя
            final userData = snapshot.data!;
            if (!_isEditing) {
              // Инициализируем контроллеры данными из Firebase
              _nameController.text = userData['name'] ?? '';
              _surnameController.text = userData['surname'] ?? '';
              _emailController.text = userData['email'] ?? '';
              _phoneController.text = userData['phoneNumber'] ?? '';
            }

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopBar(
                  searchController: _searchController,
                  onSubmitted: _onSearchSubmitted,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      width: 360,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 100,
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : userData.containsKey('imageUrl')
                                        ? NetworkImage(userData['imageUrl'])
                                        : null,
                                child: userData.containsKey('imageUrl') ||
                                        _selectedImage != null
                                    ? null
                                    : Icon(Icons.person, size: 50),
                              ),
                              _isEditing
                                  ? Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          gradient: AppColors.primaryGradient,
                                        ),
                                        width: 50,
                                        height: 50,
                                        child: IconButton(
                                            onPressed: _pickImage,
                                            icon: SvgPicture.asset(
                                              'assets/svg/editor_img.svg',
                                            )),
                                      ))
                                  : SizedBox.shrink(),
                            ],
                          ),
                          SizedBox(height: 10),
                          TextField(
                            enabled: false,
                            style: TextStyle(
                                fontFamily: AppFonts.nunitoFontFamily,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                fontFamily: AppFonts.nunitoFontFamily,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            style: TextStyle(
                                fontFamily: AppFonts.nunitoFontFamily,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            enabled: _isEditing,
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                fontFamily: AppFonts.nunitoFontFamily,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              labelText: 'Имя',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            style: TextStyle(
                                fontFamily: AppFonts.nunitoFontFamily,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            enabled: _isEditing,
                            controller: _surnameController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                fontFamily: AppFonts.nunitoFontFamily,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              labelText: 'Фамилия',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextField(
                            style: TextStyle(
                                fontFamily: AppFonts.nunitoFontFamily,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            enabled: _isEditing,
                            inputFormatters: [maskFormatter],
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelStyle: TextStyle(
                                fontFamily: AppFonts.nunitoFontFamily,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 18,
                              ),
                              labelText: 'Номер телефона',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(1)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.primaryColor,
                                      style: BorderStyle.solid)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () async {
                              if (_isEditing) {
                                String? newImageUrl;
                                if (_selectedImage != null) {
                                  try {
                                    newImageUrl =
                                        await _storage.uploadImage(
                                            _selectedImage!,
                                            userProvider.userId!);
                                    print(
                                        'Изображение успешно загружено: $newImageUrl');
                                  } catch (e) {
                                    print('Ошибка загрузки изображения: $e');
                                  }
                                }
                                // Сохраняем изменения в Firestore
                                await _userRepository.updateUserDetails(
                                  userProvider.userId!,
                                  _nameController.text,
                                  _surnameController.text,
                                  _emailController.text,
                                  _phoneController.text,
                                  newImageUrl,
                                );

                                setState(() {
                                  _isEditing =
                                      false; // Выходим из режима редактирования
                                });
                              } else {
                                setState(() {
                                  _isEditing =
                                      true; // Переходим в режим редактирования
                                });
                              }
                            },
                            child: Container(
                              width: 254,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: AppColors.buttonGradient,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  _isEditing
                                      ? 'Сохранить профиль'
                                      : 'Изменить профиль',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              userProvider.signOut(context);
                            },
                            child: Container(
                              width: 254,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: AppColors.buttonGradient,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Center(
                                child: Text(
                                  'Выйти',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                NavBar(),
              ],
            );
          } else {
            // Если данные не найдены
            return Center(child: Text('Пользователь не найден'));
          }
        },
      ),
    );
  }
}
