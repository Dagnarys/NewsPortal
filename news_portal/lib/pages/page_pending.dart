import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:intl/intl.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/repositories/news.dart';
import 'package:intl/date_symbol_data_local.dart';

class PendingNewsPage extends StatefulWidget {
  const PendingNewsPage({super.key});

  @override
  State<PendingNewsPage> createState() => _PendingNewsPageState();
}

class _PendingNewsPageState extends State<PendingNewsPage> {
  late final NewsRepository repositoryNews;

  @override
  void initState() {
    super.initState();
    repositoryNews = NewsRepository();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('ru_RU', null);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: GradientBoxBorder(gradient: AppColors.primaryGradient)
          ),
        child: Stack(children: [
          Column(
            children: [
              // Основной контент с новостями
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await repositoryNews.refreshData();
                  },
                  child: StreamBuilder<List<News>>(
                    stream: repositoryNews.getPendingNewsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
        
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('Новостей на проверке нет'));
                      }
        
                      final pendingNews = snapshot.data!;
        
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 100, bottom: 10),
                            child: Text(
                              'Список новостей на проверку',
                              style: TextStyle(
                                  fontFamily: AppFonts.nunitoFontFamily,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 250, left: 250),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16)),
                                border: GradientBoxBorder(
                                    gradient: AppColors.primaryGradient),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('ID новости'),
                                    Text('Автор'),
                                    Text('Email'),
                                    Text('Дата отправки'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Expanded(
                            child: ListView.builder(
                              padding: EdgeInsets.only(right: 250, left: 250),
                              itemCount: pendingNews.length,
                              itemBuilder: (context, index) {
                                final news = pendingNews[index];
                                return TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.only(top: 0, bottom: 0),
                                    ),
                                    onPressed: () {
                                      // context.push('/pending_news/check/${news.id}');
                                      context.pushNamed('pending-news.check',
                                          pathParameters: {'id': news.id});
                                    },
                                    child: Container(
                                      height: 67,
                                      decoration: BoxDecoration(
                                        border: GradientBoxBorder(
                                            gradient: AppColors.primaryGradient),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              news.id,
                                              style: TextStyle(
                                                  color: Color(0xFF202224),
                                                  fontFamily:
                                                      AppFonts.nunitoFontFamily,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(news.authorName,
                                                style: TextStyle(
                                                    color: Color(0xFF202224),
                                                    fontFamily:
                                                        AppFonts.nunitoFontFamily,
                                                    fontWeight: FontWeight.w600)),
                                            Text(news.authorEmail,
                                                style: TextStyle(
                                                    color: Color(0xFF202224),
                                                    fontFamily:
                                                        AppFonts.nunitoFontFamily,
                                                    fontWeight: FontWeight.w600)),
                                            Text(
                                                formatPublishedAt(
                                                    news.publishedAt),
                                                style: TextStyle(
                                                    color: Color(0xFF202224),
                                                    fontFamily:
                                                        AppFonts.nunitoFontFamily,
                                                    fontWeight: FontWeight.w600)),
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          NavBar(),
        ]),
      ),
    );
  }

  String formatPublishedAt(Timestamp? timestamp) {
    if (timestamp == null) return '';

    final date = timestamp.toDate();
    final formatter =
        DateFormat('dd MMMM yyyy HH:mm', 'ru_RU'); // Формат и локаль

    return formatter.format(date);
  }
}
