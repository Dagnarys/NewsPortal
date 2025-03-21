import 'package:flutter/material.dart';
import 'package:news_portal/components/category_bar.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/news_card.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/repositories/news.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final NewsRepository repositoryNews = NewsRepository();
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
               Expanded(child: NewsStream(repositoryNews: repositoryNews))

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

class NewsStream extends StatefulWidget {
  const NewsStream({
    super.key,
    required NewsRepository repositoryNews,
  }) : _repositoryNews = repositoryNews;

  final NewsRepository _repositoryNews;

  @override
  State<NewsStream> createState() => _NewsStreamState();
}

class _NewsStreamState extends State<NewsStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<News>>(
        stream: widget._repositoryNews.getNewsStream(),
        builder: (context, snapshot) {
         
          if (snapshot.hasData) {
 
            List<News> newsList = snapshot.data!;
            print(newsList);
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount:newsList.length,
              itemBuilder:(context,index) {
              //получаем каждый элемент
                News newsItem = newsList[index];
                return NewsCard(key: ValueKey(newsItem.id), title: newsItem.title, text: newsItem.content, newsId: newsItem.id,);
                
            },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка при загрузке новостей: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
