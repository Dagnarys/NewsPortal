import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components_web/comment_card_web.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/models/model_comment.dart';
import 'package:news_portal/repositories/news.dart';

class PageComment extends StatefulWidget {
  final String newsId;

  const PageComment({super.key, required this.newsId});

  @override
  State<PageComment> createState() => _PageCommentState();
}

class _PageCommentState extends State<PageComment> {
  late Stream<List<Comment>> _commentsStream;
  final NewsRepository _newsRepo = NewsRepository();
  @override
  void initState() {
    super.initState();
    _commentsStream = _newsRepo.getCommentsStream(widget.newsId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: GradientBoxBorder(gradient: AppColors.primaryGradient)
          ),
      child: Stack(
        children: [
          NavBar(),
          StreamBuilder<List<Comment>>(
            stream: _commentsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Ошибка: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Нет комментариев'));
              }

              final comments = snapshot.data!;

              // Делаем адаптивный Grid
              return Padding(
                padding: const EdgeInsets.only(left: 140,top: 50),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 900
                        ? 3
                        : constraints.maxWidth > 600
                            ? 2
                            : 1;
                    final itemWidth =
                        (constraints.maxWidth - (crossAxisCount + 1) * 8) /
                            crossAxisCount;

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 8,
                        childAspectRatio:
                            itemWidth / 250, // можно подобрать высоту
                      ),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return CommentCardWeb(comment: comments[index]);
                      },
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
