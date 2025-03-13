import 'package:flutter/material.dart';
import 'package:news_portal/components/category_bar.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Container(
        color: Colors.white,
        child: Column(
          children: [
            //верхняя панель
            const TopBar(),
            //пространство между верхней панелью и панелью с категориями
      
            const SizedBox(height: 5,),
            // панель с категорями 
            const CategoryBar(),
            
            //пространство для заполнения карточек с новостью
            Expanded(child: Container()),
            //нижняя панель навигации
            const NavBar(),
      
          ],
        ),
      ),
    );
  }
}