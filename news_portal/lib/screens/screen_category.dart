import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/components/list_category.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

class _ScreenCategoryState extends State<ScreenCategory> {
  final TextEditingController _searchController = TextEditingController();

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      context.pushNamed(
              'mobile-news',
              queryParameters:  {'searchQuery': value,},
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
