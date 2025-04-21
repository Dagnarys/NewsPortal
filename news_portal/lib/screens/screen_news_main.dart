import 'package:flutter/material.dart';
import 'package:news_portal/components/category_bar.dart';
import 'package:news_portal/components/filter_button.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/news_stream.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/repositories/news.dart';


class MainScreen extends StatelessWidget {
  final String? selectedCategoryId;
  const MainScreen({super.key, this.selectedCategoryId});

  @override
  Widget build(BuildContext context) {
    final NewsRepository repositoryNews = NewsRepository();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: 
      Stack(children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              //верхняя панель
              const TopBar(),
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
                      if (selectedCategoryId != null) {
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
                      selectedCategoryId: selectedCategoryId,
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

