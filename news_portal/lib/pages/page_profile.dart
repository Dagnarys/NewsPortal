
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components_web/search_widget_web.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/images.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:provider/provider.dart';
import 'package:news_portal/const/colors.dart';
import 'package:ru_phone_formatter/ru_phone_formatter.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({super.key});

  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  final TextEditingController _searchController = TextEditingController();
  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      context.goNamed('web-news', queryParameters: {'searchQuery': value});
    }
  }

  final ImagesRepository _storage = ImagesRepository();
  final UserRepository _userRepository = UserRepository();
  bool _isEditing = false;

  Uint8List? _selectedImageBytes;
  String? _fileName;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final maskFormatter = RuPhoneInputFormatter();

Future<void> _pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    if (kIsWeb) {
      // Для веба: читаем байты
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
        _fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      });
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: GradientBoxBorder(gradient: AppColors.primaryGradient)),
        child: Stack(
          children: [
            // Поисковая панель
            Positioned.fill(
              top: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchWidgetWeb(
                    controller: _searchController,
                    onSubmitted: _onSearchSubmitted,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      userProvider.signOutWeb(context);
                    },
                    child: Container(
                      width: 120, // Совпадает с width у Positioned
                      height: 50, // Совпадает с height у Positioned
                      decoration: BoxDecoration(
                        gradient: AppColors.redwhiteGradient,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
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

            // Кнопка выхода

            // Основной контент
            Positioned.fill(
              top: 100,
              right: 0,
              left: 0,
              child: FutureBuilder<Map<String, dynamic>?>(
                future: _userRepository.getUserDetails(userProvider.userId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Center(child: Text('Пользователь не найден'));
                  }

                  final userData = snapshot.data!;

                  if (!_isEditing &&
                      (_nameController.text.isEmpty ||
                          _surnameController.text.isEmpty)) {
                    _nameController.text = userData['name'] ?? '';
                    _surnameController.text = userData['surname'] ?? '';
                    _emailController.text = userData['email'] ?? '';
                    _phoneController.text = userData['phoneNumber'] ?? '';
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            width: 360,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Аватар
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    CircleAvatar(
                                      radius: 100,
                                      backgroundImage: _selectedImageBytes !=
                                              null
                                          ? Image.memory(_selectedImageBytes!,
                                                  fit: BoxFit.cover)
                                              .image
                                          : userData.containsKey('imageUrl') &&
                                                  userData['imageUrl'] != null
                                              ? NetworkImage(
                                                      userData['imageUrl'])
                                                  as ImageProvider
                                              : null,
                                      child: (_selectedImageBytes != null ||
                                              (userData.containsKey(
                                                      'imageUrl') &&
                                                  userData['imageUrl'] != null))
                                          ? null
                                          : Icon(Icons.person, size: 50),
                                    ),

                                    // Кнопка выбора изображения
                                    if (_isEditing)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            gradient: AppColors.primaryGradient,
                                          ),
                                          width: 50,
                                          height: 50,
                                          child: IconButton(
                                            onPressed: _pickImage,
                                            icon: SvgPicture.asset(
                                                'assets/svg/editor_img.svg'),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),

                                // Поля ввода
                                _buildTextField(
                                  context: context,
                                  controller: _emailController,
                                  labelText: 'Email',
                                  enabled: false,
                                ),

                                _buildTextField(
                                  context: context,
                                  controller: _nameController,
                                  labelText: 'Имя',
                                  enabled: _isEditing,
                                ),

                                _buildTextField(
                                  context: context,
                                  controller: _surnameController,
                                  labelText: 'Фамилия',
                                  enabled: _isEditing,
                                ),

                                TextField(
                                  style: TextStyle(
                                    fontFamily: AppFonts.nunitoFontFamily,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
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
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(1),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: AppColors.primaryColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: AppColors.primaryColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                ),

                                // Кнопка сохранения
                                SizedBox(height: 20),
                                TextButton(
                                  onPressed: () async {
                                    if (_isEditing) {
                                      String? newImageUrl;

                                      if (_selectedImageBytes != null &&
                                          _fileName != null) {
                                        try {
                                          newImageUrl =
                                              await _storage.uploadImageWeb(
                                                  imageBytes:
                                                      _selectedImageBytes!,
                                                  userId: userProvider.userId!,
                                                  fileName: _fileName!);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Ошибка загрузки: $e')),
                                          );
                                        }
                                      }

                                      await _userRepository.updateUserDetails(
                                        userProvider.userId!,
                                        _nameController.text,
                                        _surnameController.text,
                                        _emailController.text,
                                        _phoneController.text,
                                        newImageUrl,
                                      );

                                      setState(() {
                                        _isEditing = false;
                                        _selectedImageBytes = null;
                                      });
                                    } else {
                                      setState(() {
                                        _isEditing = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 254,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.buttonGradient,
                                      borderRadius: BorderRadius.circular(10),
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
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Навигационная панель
            const NavBar(),
          ],
        ),
      ),
    );
  }

  // Вспомогательный метод для создания текстовых полей
  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String labelText,
    bool enabled = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        style: TextStyle(
          fontFamily: AppFonts.nunitoFontFamily,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
          labelStyle: TextStyle(
            fontFamily: AppFonts.nunitoFontFamily,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontSize: 18,
          ),
          labelText: labelText,
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: AppColors.primaryColor,
              style: BorderStyle.solid,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(1),
            borderSide: BorderSide(
              width: 1,
              color: AppColors.primaryColor,
              style: BorderStyle.solid,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              width: 1,
              color: AppColors.primaryColor,
              style: BorderStyle.solid,
            ),
          ),
        ),
      ),
    );
  }
}
