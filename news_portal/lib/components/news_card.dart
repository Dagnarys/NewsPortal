import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/screens/screen_comment.dart';
import 'package:news_portal/screens/screen_new.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String content;
  final String newsId;
  final String nameCategory;
  final List<String> imageUrls;
  const NewsCard({
  super.key,
  required this.title,
  required this.content,
  required this.newsId,
  required this.nameCategory,
  required this.imageUrls,
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ScreenNew(
                        newsId: newsId,
                        content: content,
                        title: title,
                        imageUrls: imageUrls,
                      )));
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(8, 55, 8, 8),
          width: 321,
          height: 205,
          decoration: BoxDecoration(
            color: imageUrls.isEmpty ? Colors.grey[300] : null,
            image: imageUrls.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(imageUrls.first),
                    fit: BoxFit.cover,
                  )
                : null,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            children: [
              Text(
                title,
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
                  content,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: AppFonts.nunitoFontFamily,
                      color: Colors.white)),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    nameCategory,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppFonts.nunitoFontFamily,
                        color: Colors.white),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScreenComment(
                                        newsId: newsId,
                                      )));
                        },
                        icon: SvgPicture.asset(
                          'assets/svg/comment.svg',
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text('1234',
                          style: TextStyle(
                              fontSize: 10,
                              fontFamily: AppFonts.nunitoFontFamily,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB3B3B3))),
                      SizedBox(
                        width: 4,
                      ),
                      SvgPicture.asset(
                        'assets/svg/eye.svg',
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text('1234',
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
}
