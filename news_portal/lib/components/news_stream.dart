import 'package:flutter/material.dart';
import 'package:news_portal/components/news_card.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/providers/category_provider.dart';
import 'package:news_portal/repositories/categories.dart';
import 'package:news_portal/repositories/news.dart';
import 'package:provider/provider.dart';

class NewsStream extends StatefulWidget {
  final NewsRepository _repositoryNews;
  final String? selectedCategoryId;
  final String searchQuery; // <-- Новое поле

  const NewsStream({
    super.key,
    required NewsRepository repositoryNews,
    required this.selectedCategoryId,
    this.searchQuery = '',
  }) : _repositoryNews = repositoryNews;

  @override
  State<NewsStream> createState() => _NewsStreamState();
}

class _NewsStreamState extends State<NewsStream> {
  @override
  Widget build(BuildContext context) {
    final categoryRepo = Provider.of<CategoryProvider>(context).repository;

    return StreamBuilder<List<News>>(
      stream: widget._repositoryNews
          .getNewsStream(categoryId: widget.selectedCategoryId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<News> newsList = snapshot.data!;
          newsList = _applyFilters(newsList);
          // Фильтрация новостей по выбранной категории
          // Проверка на пустой список новостей
          if (newsList.isEmpty) {
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(), // Разрешаем прокрутку
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height, // Высота экрана
                child: Text(
                  'Новостей с выбранной категорией нет',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: AppFonts.nunitoFontFamily,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: _fetchNewsWithCategoryNames(newsList, categoryRepo),
            builder: (context, categorySnapshot) {
              if (categorySnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (categorySnapshot.hasError) {
                return Center(child: Text('Ошибка: ${categorySnapshot.error}'));
              } else {
                final newsWithCategories = categorySnapshot.data!;
                return ListView.builder(

                  padding: EdgeInsets.only(bottom: 60),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: newsWithCategories.length,
                  itemBuilder: (context, index) {
                    final newsItem = newsWithCategories[index];
                    if ((newsItem['images'] as List<String>).isEmpty) {
                      print(
                          "⚠️ Новость ${newsItem['title']} не имеет изображений");
                      return SizedBox(); // или placeholder
                    }

                    return NewsCard(
                      key: ValueKey(newsItem['id']),
                      title: newsItem['title'],
                      content: newsItem['content'],
                      newsId: newsItem['id'],
                      nameCategory: '#${newsItem['categoryName']}',
                      imageUrls: newsItem['images'] as List<String>,
                    );
                  },
                );
              }
            },
          );
        } else if (snapshot.hasError) {
          return Center(
              child: Text('Ошибка при загрузке новостей: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  // Метод для загрузки новостей с именами категорий
  Future<List<Map<String, dynamic>>> _fetchNewsWithCategoryNames(
      List<News> newsList, CategoriesRepository categoriesRepo) async {
    final newsWithCategories = <Map<String, dynamic>>[];

    for (final news in newsList) {
      final categoryName = await news.getCategoryName(categoriesRepo);

      newsWithCategories.add({
        'id': news.id,
        'title': news.title,
        'content': news.content,
        'categoryName': categoryName,
        'images': news.images,
      });
    }

    return newsWithCategories;
  }
  List<News> _applyFilters(List<News> newsList) {
  if (widget.selectedCategoryId != null && widget.selectedCategoryId!.isNotEmpty) {
    newsList = newsList.where((n) => n.categoryId == widget.selectedCategoryId).toList();
  }

  if (widget.searchQuery.isNotEmpty) {
    final lowerQuery = widget.searchQuery.toLowerCase();
    newsList = newsList
        .where((n) => n.title.toLowerCase().contains(lowerQuery) || 
              n.content.toLowerCase().contains(lowerQuery))
        .toList();
  }

  return newsList;
}
}


