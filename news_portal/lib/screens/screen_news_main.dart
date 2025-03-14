import 'package:flutter/material.dart';
import 'package:news_portal/components/category_bar.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/news_card.dart';
import 'package:news_portal/components/top_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
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
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    const SizedBox(
                      height: 7,
                    ),
                    NewsCard(),
                    NewsCard(),
                    NewsCard(),
                    NewsCard(),
                    // Можно добавить больше NewsCard() при необходимости
                  ],
                ),
              ),

              //пространство для заполнения карточек с новостью
              //нижняя панель навигации
            ],
          ),
        ),
        const NavBar(),
      ]),
    );
  }
}
