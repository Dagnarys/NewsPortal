import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/providers/category_provider.dart';
import 'package:news_portal/repositories/news.dart';
import 'package:provider/provider.dart';

class NewsCardWeb extends StatelessWidget {
  final News news;

  const NewsCardWeb({
    super.key,
    required this.news,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {
          context.goNamed('web-news-detail',pathParameters: {'id':news.id});
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          fixedSize: Size(333, 333),
        ),
        child: Container(
          width: 455,
          height: 333,
          padding: EdgeInsets.fromLTRB(8, 55, 8, 8),
          decoration: BoxDecoration(
            color: news.imageUrls.isEmpty ? Colors.grey[300] : Colors.grey[300],
            image: news.imageUrls.isNotEmpty
                ? DecorationImage(
                    image: CachedNetworkImageProvider((news.imageUrls.first)),
                    fit: BoxFit.cover,
                  )
                : null,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                news.title,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: AppFonts.nunitoSansFontFamily,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 26),
              Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                news.content,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: AppFonts.nunitoFontFamily,
                  color: Colors.white,
                ),
              ),
              Expanded(child: SizedBox()),
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
                      IconButton(
                        isSelected: true,
                        padding: EdgeInsets.all(0),
                        icon: SvgPicture.asset(
                          'assets/svg/comment.svg',
                          width: 40,
                        ),
                        onPressed: () {
                          context.goNamed('web-news-comment',pathParameters: {'id':news.id});
                        },
                      ),
                      SizedBox(width: 2),
                      StreamBuilder<int>(
                        stream: NewsRepository().getCommentCount(news.id),
                        builder: (context, snapshot) {
                          final int commentCount = snapshot.data ?? 0;
                          return Text(
                            '$commentCount',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: AppFonts.nunitoFontFamily,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB3B3B3),
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 4),
                      SvgPicture.asset(
                        'assets/svg/eye.svg',
                        width: 40,
                      ),
                      SizedBox(width: 2),
                      Text(
                        '${news.viewCount}',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: AppFonts.nunitoFontFamily,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB3B3B3),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
