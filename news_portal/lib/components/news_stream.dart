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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<News>>(
      stream: newsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Ошибка загрузки: ${snapshot.error}"));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Новостей нет"));
        }

        final List<News> newsList = snapshot.data!;

        return ListView.builder(
          itemCount: newsList.length,
          itemBuilder: (context, index) {
            return NewsCard(news: newsList[index]);
          },
        );
      },
    );
  }
}