import 'package:flutter/material.dart';
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
  final NewsRepository repositoryNews = NewsRepository();
  late final TextEditingController _searchController;
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
    _searchQuery = widget.searchQuery ?? '';
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _searchQuery = value.toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NewsRepository repositoryNews = NewsRepository();
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
                    // Сбрасываем категорию (опционально)
                    if (widget.selectedCategoryId != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                    // Обновляем данные
                    await repositoryNews.refreshData();
                  },
                  child: NewsStream(
                    repositoryNews: repositoryNews,
                    selectedCategoryId: widget.selectedCategoryId,
                    searchQuery: _searchQuery,
                  ),
                ),
              ),

              //пространство для заполнения карточек с новостью
              //нижняя панель навигации
            ],
          ),
        ),
        FilterButton(),
        const NavBar(),
      ]),
    );
  }
}


