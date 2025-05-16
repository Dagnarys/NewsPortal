import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/providers/category_provider.dart';
import 'package:news_portal/repositories/news.dart';
import 'package:provider/provider.dart';

class NewsCard extends StatelessWidget {
  final News news;
  

  const NewsCard({
    super.key, required this.news,
    

  });

  @override
  Widget build(BuildContext context) {
     print(news.imageUrls);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {
          context.push('/new/${news.id}');
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 55, 8, 8),
          width: 321,
          height: 205,
          decoration: BoxDecoration(
           
            color: news.imageUrls.isEmpty ? Colors.grey[300] : null,
            image: news.imageUrls.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(news.imageUrls.first),
                    fit: BoxFit.cover,
                    
                  )
                : null,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            children: [
              Text(
                news.title,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.nunitoSansFontFamily,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 26,
              ),
              Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  news.content,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppFonts.nunitoFontFamily,
                      color: Colors.white)),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder<String>(
                    future: _getCategoryName(context),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text('#загрузка', style: TextStyle(color: Colors.white));
                      }
                      return Text(
                        snapshot.data!,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Nunito',
                          color: Colors.white,
                        ),
                      );
                    }),
                  Row(
                    children: [
                      IconButton( padding: EdgeInsets.all(0),
                      alignment: Alignment.centerRight,
                        onPressed: () {
                          
                          context.pushNamed('mobile-news-comment',extra: {'title':news.title,'id':news.id});
                          
                        },
                        icon: SvgPicture.asset(
                          
                          'assets/svg/comment.svg',
                        ),
                      ),
                      // SizedBox(
                      //   width: 2,
                      // ),
                      StreamBuilder<int>(
                        stream: NewsRepository().getCommentCount(news.id),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("Ошибка",
                                style: TextStyle(color: Colors.red));
                          }

                          final int commentCount = snapshot.data ?? 0;

                          return Text(
                            '$commentCount',
                            style: TextStyle(
                                fontSize: 10,
                                fontFamily: AppFonts.nunitoFontFamily,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB3B3B3)),
                          );
                        },
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      SvgPicture.asset(
                        'assets/svg/eye.svg',
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text('${news.viewCount}',
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: AppFonts.nunitoFontFamily,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB3B3B3))),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
   Future<String> _getCategoryName(BuildContext context) async {
    try {
      final category = await Provider.of<CategoryProvider>(context, listen: false)
          .repository
          .getCategory(news.categoryId);
      return '#${category?.name ?? 'без категории'}';
    } catch (e) {
      print('Ошибка получения категории: $e');
      return '#ошибка';
    }
  }
}
