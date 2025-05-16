import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as found;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_portal/components/dialog_indicator.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/models/model_categories.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/categories.dart';
import 'package:news_portal/repositories/images.dart';
import 'package:provider/provider.dart';

class ScreenAdd extends StatefulWidget {
  const ScreenAdd({super.key});

  @override
  State<ScreenAdd> createState() => _ScreenAddState();
}

class _ScreenAddState extends State<ScreenAdd> {
  late final ImagesRepository _storageRepository = ImagesRepository();
  late final CategoriesRepository _categoriesRepository;
  List<Category> _categories = [];
  Category? _selectedCategory;
  final GlobalKey<UploadProgressDialogState> progressKey = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<XFile> _selectedImages = []; // Для хранения выбранных изображений

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _categoriesRepository = CategoriesRepository();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final snapshot = await _categoriesRepository.getCategories().first;
      setState(() {
        _categories = snapshot;
        if (_categories.isNotEmpty) {
          _selectedCategory =
              _categories.first; // по умолчанию первая категория
        }
      });
    } catch (e) {
      print('Ошибка при загрузке категорий: $e');
    }
  }

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      context.go('/',
          extra: {'categoryId': null, 'searchQuery': value.toLowerCase()});
    }
  }

  void _clearForm() {
    setState(() {
      _titleController.clear();
      _contentController.clear();
      _selectedImages.clear();
      _selectedCategory = null;
    });
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _selectedImages.length,
          itemBuilder: (context, index) {
            final XFile image = _selectedImages[index];

            return Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: found.kIsWeb ||
                          ![TargetPlatform.android, TargetPlatform.iOS]
                              .contains(found.defaultTargetPlatform)
                      ? FutureBuilder<found.Uint8List>(
                          future: image.readAsBytes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Image.memory(
                                snapshot.data!,
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                              );
                            } else if (snapshot.hasError) {
                              return Icon(Icons.error);
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                        )
                      : Image.file(
                          File(image.path),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedImages.removeAt(index);
                    });
                  },
                  icon: Icon(Icons.close, color: Colors.red),
                ),
              ],
            );
          },
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.all(0),
          ),
          onPressed: () async {
            final picker = ImagePicker();
            final pickedFiles =
                await picker.pickMultiImage(); // множественный выбор
            if (pickedFiles.isNotEmpty) {
              setState(() {
                _selectedImages.addAll(pickedFiles);
              });
            }
          },
          child: Container(
            width: 200,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              gradient: AppColors.buttonGradient,
            ),
            child: Center(
              child: Text(
                'Загрузить фотографию',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'Оглавление',
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
    );
  }

  Widget _buildCategoryDropdown() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Категория',
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Category>(
          dropdownColor: Colors.white,
          value: _selectedCategory,
          isExpanded: true,
          items: _categories.map((category) {
            return DropdownMenuItem<Category>(
              value: category,
              child: Text(
                category.name,
                style: TextStyle(
                    fontFamily: AppFonts.nunitoFontFamily,
                    fontWeight: FontWeight.w600),
              ),
            );
          }).toList(),
          onChanged: (Category? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: _contentController,
      maxLines: 10,
      decoration: InputDecoration(
        labelText: 'Текст статьи',
        hintText: 'Введите текст новости...',
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
    );
  }

  Widget _buildSubmitButton() {
    return TextButton(
      onPressed: () async {
        final int imageCount = _selectedImages.length;

        if (_selectedCategory == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Выберите категорию')),
          );
          return;
        }

        // Показываем диалог с прогрессом
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          transitionDuration: Duration(milliseconds: 200),
          pageBuilder: (_, __, ___) => UploadProgressDialog(
            key: progressKey,
            totalImages: imageCount,
          ),
        );

        try {
          // Ждем немного, чтобы виджет успел построиться
          await Future.delayed(Duration(milliseconds: 100));

          final newsRef = FirebaseFirestore.instance.collection('news').doc();
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          await newsRef.set({
            'title': _titleController.text,
            'id_category': _selectedCategory!.id,
            'content': _contentController.text,
            'createdAt': FieldValue.serverTimestamp(),
            'authorId': userProvider.userId ?? '',
            'authorName': userProvider.userFullName,
            'authorEmail':userProvider.userEmail,
            'commentCount': 0,
            'viewCount': 0,
            'publishedAt': FieldValue.serverTimestamp(),
            'status': 'pending',
          });

          progressKey.currentState?.incrementProgress("Новость создана");

         // Загружаем изображения
        for (int i = 0; i < _selectedImages.length; i++) {
          final XFile image = _selectedImages[i];
          final bytes = await image.readAsBytes(); // Читаем байты сразу
          
          final imageUrl = await _storageRepository.uploadImageMoblie(
            imageBytes: bytes,
            userId: userProvider.userId!,
            fileName: '${DateTime.now().millisecondsSinceEpoch}_image_$i.jpg',
          );
          
          await newsRef.collection('images').add({'image': imageUrl});
          progressKey.currentState?.incrementProgress(
            "Загрузка $i из ${_selectedImages.length}");
        }
            

          Navigator.pop(context); // Закрыть диалог
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Новость успешно добавлена')),
          );
          _clearForm();
        } catch (e) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка при сохранении: $e')),
          );
        }
      },
      child: Container(
        width: 145,
        height: 32,
        decoration: BoxDecoration(
          gradient: AppColors.buttonGradient,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Text(
            'Отправить',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    _buildImageSection(),
                    SizedBox(height: 20),
                    _buildTitleField(),
                    SizedBox(height: 20),
                    _buildCategoryDropdown(),
                    SizedBox(height: 20),
                    _buildContentField(),
                    SizedBox(height: 20),
                    // _buildContentEditor(),
                    SizedBox(height: 20),
                    _buildSubmitButton(),
                  ],
                ),
              )
            ],
          )),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopBar(
                searchController: _searchController,
                onSubmitted: _onSearchSubmitted),
          ),
        ],
      ),
    );
  }
}
