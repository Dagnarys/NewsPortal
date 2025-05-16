import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components_web/news_stream_web.dart';
import 'package:news_portal/components_web/search_widget_web.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/news.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final String? selectedCategoryId;
  final String? searchQuery;
  const MainPage({super.key, this.selectedCategoryId, this.searchQuery});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final NewsRepository repositoryNews;
  late final TextEditingController _searchController;
  late String _searchQuery;
  @override
  void initState() {
    super.initState();
    repositoryNews = NewsRepository();
    _searchController = TextEditingController(text: widget.searchQuery);
    _searchQuery = widget.searchQuery ?? '';
    print("Полученный selectedCategoryId: ${widget.selectedCategoryId}");
    print("Полученный searchQuery: ${widget.searchQuery}");
  }

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      context.goNamed('web-news', queryParameters: {
        'searchQuery': value,
      });
    }
  }

  @override
  void didUpdateWidget(covariant MainPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery) {
      _searchQuery = widget.searchQuery ?? '';
      _searchController.text = _searchQuery;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print("Категория: ${widget.selectedCategoryId}"); // ← выводит ID
    print("Search Query: ${widget.searchQuery}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: GradientBoxBorder(gradient: AppColors.primaryGradient)
          ),
        child: Stack(
          children: [
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
            Positioned.fill(top: 0, left: 0, bottom: 0, child: const NavBar()),
            Positioned.fill(
              top: 80, // Отступ от верхнего края
              child: Padding(
                padding: EdgeInsets.only(left: 150), // Отступ слева
                child: NewsStreamWeb(
                  searchQuery: widget.searchQuery,
                  repositoryNews: repositoryNews,
                  selectedCategoryId: widget.selectedCategoryId,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
