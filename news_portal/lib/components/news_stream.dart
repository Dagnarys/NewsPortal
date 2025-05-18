import 'package:flutter/material.dart';
import 'package:news_portal/components/news_card.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/repositories/news.dart';

enum SortOption {
  newest,   // Сначала новые
  oldest,   // Сначала старые
  mostViews, // Больше просмотров
  leastViews, // Меньше просмотров
}

class NewsStream extends StatefulWidget {
  final NewsRepository repositoryNews;
  final String? selectedCategoryId;
  final String? searchQuery;
  final SortOption sortOption;
  final bool isAscending;

  const NewsStream({
    super.key,
    required this.repositoryNews,
    this.selectedCategoryId,
    this.searchQuery,
    this.sortOption = SortOption.newest,
    this.isAscending = false,
  });

  @override
  State<NewsStream> createState() => _NewsStreamState();
}

class _NewsStreamState extends State<NewsStream> {
  Stream<List<News>> newsStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    newsStream = _buildNewsStream();
  }

  @override
  void didUpdateWidget(covariant NewsStream oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Пересоздаем поток только при изменении ключевых параметров
    if (oldWidget.selectedCategoryId != widget.selectedCategoryId ||
        oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.sortOption != widget.sortOption ||
        oldWidget.isAscending != widget.isAscending) {
      newsStream = _buildNewsStream();
    }
  }

  /// Создает поток новостей с учетом всех фильтров и сортировок
  Stream<List<News>> _buildNewsStream() {
    return widget.repositoryNews.getNewsStreamWithImages(
      categoryId: widget.selectedCategoryId,
      searchQuery: widget.searchQuery,
      sortOption: widget.sortOption,
      isAscending: widget.isAscending,
    );
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
    return StreamBuilder<List<News>>(
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



        return ListView.builder(
          itemCount: filteredNews.length,
          itemBuilder: (context, index) {
            return NewsCard(news: filteredNews[index]);
          },
        );
      },
    );
  }
}