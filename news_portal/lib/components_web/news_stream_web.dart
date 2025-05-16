import 'package:flutter/material.dart';
import 'package:news_portal/components_web/news_card_web.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/repositories/news.dart';

class NewsStreamWeb extends StatefulWidget {
  final NewsRepository repositoryNews;
  final String? selectedCategoryId;
  final String? searchQuery;

  const NewsStreamWeb({
    super.key,
    required this.repositoryNews,
    this.selectedCategoryId,
    this.searchQuery,
  });

  @override
  State<NewsStreamWeb> createState() => _NewsStreamState();
}

class _NewsStreamState extends State<NewsStreamWeb> {
  late final Stream<List<News>> newsStream;

  @override
  void initState() {
    super.initState();
    newsStream = widget.repositoryNews
        .getNewsStreamWithImages(); // ← получаем все новости
  }

  @override
  void didUpdateWidget(covariant NewsStreamWeb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.selectedCategoryId != widget.selectedCategoryId) {
      newsStream =
          widget.repositoryNews.getNewsStreamWithImages(); 
    }
  }

  List<News> _applyContentFilter(List<News> newsList) {
    if (widget.searchQuery == null || widget.searchQuery!.trim().isEmpty) {
      return newsList; // возвращаем все новости, если запрос пустой
    }

    final lowerQuery = widget.searchQuery!.toLowerCase().trim();
    return newsList
        .where((news) => news.content.toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 150),
      child: StreamBuilder<List<News>>(
        stream: newsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Ошибка загрузки: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Новостей нет"));
          }

          final List<News> allNews = snapshot.data!;
          print("Все новости: $allNews");

          // Фильтрация по категории
          List<News> filteredByCategory = allNews;
          if (widget.selectedCategoryId != null &&
              widget.selectedCategoryId!.isNotEmpty) {
            filteredByCategory = allNews
                .where((news) => news.categoryId == widget.selectedCategoryId)
                .toList();

            print("После фильтрации по категории: $filteredByCategory");
          }

          // Фильтрация по поисковому запросу
          List<News> filteredNews = _applyContentFilter(filteredByCategory);
          print("После фильтрации по запросу: $filteredNews");

          if (filteredNews.isEmpty) {
            // Показываем специальное сообщение только при активных фильтрах
            if (widget.selectedCategoryId != null ||
                (widget.searchQuery?.isNotEmpty ?? false)) {
              return Center(
                  child: Text("Новостей по вашему запросу не найдено"));
            } else {
              return Center(child: Text("Новостей нет"));
            }
          }

          // Сетка с 3 карточками в ряд
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // ← 3 карточки в ряд
              mainAxisSpacing: 16, // Отступ между строками
              crossAxisSpacing: 16, // Отступ между колонками
              childAspectRatio: 1.2, // Соотношение ширины и высоты
            ),
            itemCount: filteredNews.length,
            itemBuilder: (context, index) {
              return NewsCardWeb(news: filteredNews[index]);
            },
          );
        },
      ),
    );
  }
}
