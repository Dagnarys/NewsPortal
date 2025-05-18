import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/components/category_bar.dart';
import 'package:news_portal/components/filter_button.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/news_stream.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/repositories/news.dart';

class MainScreen extends StatefulWidget {
  final String? selectedCategoryId;
  final String? searchQuery;
  const MainScreen({super.key, this.selectedCategoryId, this.searchQuery});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  SortOption _sortOption = SortOption.newest;
  bool _isAscending = false;
  late final NewsRepository repositoryNews;
  late final TextEditingController _searchController;
  late String _searchQuery;
  @override
  void initState() {
    super.initState();
    repositoryNews = NewsRepository();
    _searchController = TextEditingController(text: widget.searchQuery);
    _searchQuery = widget.searchQuery!;
    print("Полученный selectedCategoryId: ${widget.selectedCategoryId}");
    print("Полученный searchQuery: ${widget.searchQuery}");
  }
  void _updateSortOption(SortOption option, bool isAscending) {
  setState(() {
    _sortOption = option;
    _isAscending = isAscending;
  });
}
  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _searchQuery = widget.searchQuery ?? '';
      _searchController.text = _searchQuery;
    }
  }

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      context.goNamed('mobile-news', queryParameters: {'searchQuery': value});
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Категория: ${widget.selectedCategoryId}"); // ← выводит ID
    print("Search Query: ${widget.searchQuery}");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              //верхняя панель
              TopBar(
                searchController: _searchController,
                onSubmitted: _onSearchSubmitted,
              ),
              //пространство между верхней панелью и панелью с категориями

              const SizedBox(
                height: 5,
              ),
              // панель с категорями
              const CategoryBar(),

              const SizedBox(
                height: 0,
              ),
              // Обертка для обновления при свайпе
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await repositoryNews.refreshData();
                  },
                  child: NewsStream(
                    sortOption: _sortOption,
                    isAscending: _isAscending,
                    repositoryNews: repositoryNews,
                    selectedCategoryId: widget.selectedCategoryId,
                    searchQuery: _searchQuery,
                  ),
                ),
              )

              //пространство для заполнения карточек с новостью
              //нижняя панель навигации
            ],
          ),
        ),
        FilterButton(onSortSelected: _updateSortOption),
        const NavBar(),
      ]),
    );
  }
}
