import 'package:flutter/material.dart';
import 'package:news_portal/components/news_card.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/providers/category_provider.dart';
import 'package:news_portal/repositories/categories.dart';
import 'package:news_portal/repositories/news.dart';
import 'package:provider/provider.dart';

class NewsStream extends StatefulWidget {
  const NewsStream({
    super.key,
    required NewsRepository repositoryNews,
  }) : _repositoryNews = repositoryNews;

  final NewsRepository _repositoryNews;

  @override
  State<NewsStream> createState() => _NewsStreamState();
}

class _NewsStreamState extends State<NewsStream> {
  @override
  Widget build(BuildContext context) {
    final categoryRepo = Provider.of<CategoryProvider>(context).repository;

    return StreamBuilder<List<News>>(
      stream: widget._repositoryNews.getNewsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<News> newsList = snapshot.data!;
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
                  padding: EdgeInsets.all(0),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: newsWithCategories.length,
                  itemBuilder: (context, index) {
                    final newsItem = newsWithCategories[index];
                    return NewsCard(
                      key: ValueKey(newsItem['id']),
                      title: newsItem['title'],
                      content: newsItem['content'],
                      newsId: newsItem['id'],
                      name_category: '#${newsItem['categoryName']}',
                    );
                  },
                );
              }
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка при загрузке новостей: ${snapshot.error}'));
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
      });
    }

    return newsWithCategories;
  }
}