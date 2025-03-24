import 'package:flutter/material.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/repositories/news.dart';

class ScreenNew extends StatelessWidget {
  final String newsId;
  final NewsRepository repositoryNews = NewsRepository();
  final String title;
  final String content;
  ScreenNew({
    super.key,
    required this.newsId,
    required this.content,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TopBar(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '25 октября 2024',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    title,
                    style: null,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Автор текста: Марина Ткачева',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '#категория #категория',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      Spacer(),
                      Text(
                        '© 1234',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    content,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 150, // Задайте нужную высоту
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Ваши элементы списка
                        Container(
                          width: 100,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 100,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 100,
                          color: Colors.green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // Ваши элементы списка
                        Container(
                          width: 100,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 100,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 300,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
