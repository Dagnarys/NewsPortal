import 'package:flutter/material.dart';
import 'package:news_portal/components/list_category.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/screens/screen_news_main.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      Navigator.pushAndRemoveUntil(
        
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(
            searchQuery: value.toLowerCase(), // ← Передаём поисковый запрос
          ),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(children: [
        TopBar(
          searchController: _searchController,
          onSubmitted: _onSearchSubmitted,
        ),
        ListCategory(),
        Expanded(child: Container()),
        NavBar()
      ]),
    );
  }
}
