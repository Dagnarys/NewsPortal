import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components_web/search_widget_web.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/news.dart';
import 'package:provider/provider.dart';

class PageEdit extends StatefulWidget {
  final String newsId;
  const PageEdit({super.key, required this.newsId});

  @override
  State<PageEdit> createState() => _PageEditState();
}

class _PageEditState extends State<PageEdit> {
  List<String> existingImageUrls = []; // Существующие изображения из Firestore
  List<XFile> newImages = []; // Новые изображения, выбранные пользователем
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _searchController = TextEditingController();
  late TextEditingController _titleController = TextEditingController();
  late TextEditingController _contentController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final NewsRepository repositoryNews;
  late News _currentNews;
  List<String> _imageUrls = [];
  bool _isLoading = false;

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      context.goNamed('web-news', queryParameters: {'searchQuery': value});
    }
  }

  Future<void> _loadNews() async {
    final news = await repositoryNews.getNewsById(widget.newsId);
    setState(() {
      _currentNews = news;
      _titleController.text = news.title;
      _contentController.text = news.content;
      _imageUrls = List.from(news.imageUrls);
      existingImageUrls = List.from(news.imageUrls);
    });
  }

  Future<void> _addImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage(); // Множественный выбор

    if (pickedFiles.isNotEmpty) {
      setState(() {
        newImages.addAll(pickedFiles);
      });
    }
  }

  Future<void> _deleteImage(int index) async {
    if (index < existingImageUrls.length) {
      // Удаляем существующее изображение из Firestore и Storage
      final DocumentReference newsRef =
          _firestore.collection('news').doc(widget.newsId);
      final String imageUrl = existingImageUrls[index];

      await newsRef
          .collection('images')
          .where('image', isEqualTo: imageUrl)
          .get()
          .then((snapshot) async {
        for (DocumentSnapshot doc in snapshot.docs) {
          final Uri uri = Uri.parse(imageUrl);
          final String imagePath = uri.path;

          try {
            await _storage.ref().child(imagePath).delete();
          } catch (e) {
            if (e is FirebaseException && e.code != 'object-not-found') {
              print('Ошибка при удалении изображения из Storage: $e');
            }
          }

          await doc.reference.delete();
        }
      });

      setState(() {
        existingImageUrls.removeAt(index);
      });
    } else {
      // Удаляем новое изображение из временного списка
      setState(() {
        newImages.removeAt(index - existingImageUrls.length);
      });
    }
  }

  Future<void> _saveNews() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty)
      return;

    setState(() => _isLoading = true);

    try {
      await repositoryNews.updateNews(
          News(
              id: widget.newsId,
              title: _titleController.text,
              content: _contentController.text,
              imageUrls: [...existingImageUrls, ...newImages.map((x) => '')],
              categoryId: _currentNews.categoryId,
              authorEmail: _currentNews.authorEmail,
              authorName: _currentNews.authorName,
              publishedAt: Timestamp.now(),
              status: 'approved'),
          newImages,
          existingImageUrls);

      context.goNamed('web-news');
    } catch (e) {
      // Показать ошибку
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка сохранения новости')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    repositoryNews = NewsRepository();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _loadNews();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: GradientBoxBorder(gradient: AppColors.primaryGradient)),
          child: Stack(children: [
            NavBar(),
            Column(children: [
              const SizedBox(height: 10),
              Row(
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
                      width: 120,
                      height: 50,
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
              SizedBox(
                height: 10,
              ),
              Text(
                'Проверка новости',
                style: TextStyle(
                    fontFamily: AppFonts.nunitoFontFamily,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                  width: 1400,
                  height: 700,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      border: GradientBoxBorder(
                          gradient: AppColors.primaryGradient)),
                  child: Expanded(
                      child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Заголовок',
                                style: TextStyle(
                                    fontFamily: AppFonts.nunitoFontFamily,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 1000,
                                child: TextField(
                                  style: TextStyle(
                                    fontFamily: AppFonts.nunitoFontFamily,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  controller: _titleController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: AppColors.primaryColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
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
                              ),
                              Text(
                                'Содержание',
                                style: TextStyle(
                                    fontFamily: AppFonts.nunitoFontFamily,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 1300,
                                height: 500,
                                child: TextField(
                                  minLines: 2,
                                  maxLines: 40,
                                  style: TextStyle(
                                    overflow: TextOverflow.visible,
                                    fontFamily: AppFonts.nunitoFontFamily,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  controller: _contentController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: AppColors.primaryColor,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
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
                              ),
                            ]),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                ),
                                onPressed: () {
                                  _saveNews();
                                },
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.buttonGradient,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Сохранить новость',
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
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                ),
                                onPressed: () async {
                                  final picker = ImagePicker();
                                  final pickedFiles = await picker
                                      .pickMultiImage(); // множественный выбор
                                  if (pickedFiles.isNotEmpty) {
                                    setState(() {
                                      newImages.addAll(pickedFiles);
                                    });
                                  }
                                },
                                child: Container(
                                  width: 200,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: AppColors.buttonGradient,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Загрузить фотографии',
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
                      SliverToBoxAdapter(
                        child: _buildImageSection(),
                      ),
                    ],
                  )))
            ])
          ])),
    );
  }

  Widget _buildImageSection() {
    return Column(
      children: [
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
          ),
          itemCount: existingImageUrls.length +
              newImages.length +
              1, // +1 для кнопки добавления
          itemBuilder: (context, index) {
            // Последняя ячейка - кнопка добавления
            if (index == existingImageUrls.length + newImages.length) {
              return _buildAddImageButton();
            }

            // Обработка существующих и новых изображений
            return _buildImageItem(index);
          },
        ),
      ],
    );
  }

// Кнопка добавления изображения
  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _addImage,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 40, color: Colors.grey),
            Text(
              'Добавить фото',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

// Один элемент изображения (существующее или новое)
  Widget _buildImageItem(int index) {
    final bool isExisting = index < existingImageUrls.length;

    return Stack(
      alignment: Alignment.topRight,
      children: [
        // Обертка с тенью и границей
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isExisting
                ? _buildExistingImage(index)
                : _buildNewImage(index - existingImageUrls.length),
          ),
        ),

        // Кнопка удаления
        Positioned(
          top: -8,
          right: -8,
          child: GestureDetector(
            onTap: () => _deleteImage(index),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

// Отображение существующего изображения
  Widget _buildExistingImage(int index) {
    return Image.network(
      existingImageUrls[index],
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
    );
  }

// Отображение нового изображения
  Widget _buildNewImage(int index) {
    final XFile image = newImages[index];

    return FutureBuilder<Uint8List>(
      future: image.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          );
        } else if (snapshot.hasError) {
          return Icon(Icons.error);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
