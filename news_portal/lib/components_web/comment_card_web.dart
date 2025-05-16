// comment_card.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/models/model_comment.dart';
import 'package:news_portal/repositories/news.dart';

class CommentCardWeb extends StatelessWidget {
  final Comment comment;
  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final now = DateTime.now();

    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return "Только что";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} мин назад";
    } else if (difference.inDays < 1) {
      return "${difference.inHours} ч назад";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} дн назад";
    } else {
      return "${date.day}.${date.month}.${date.year}";
    }
  }

  const CommentCardWeb({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(comment.userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text(
                "Загрузка...",
                style: TextStyle(decoration: TextDecoration.none),
              );
            }

            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              padding: EdgeInsets.all(10),
              height: 150,
              width: 344,
              decoration: BoxDecoration(
                  gradient: AppColors.buttonGradient,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${userData['name']} ${userData['surname']}",
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              color: Colors.black,
                              fontFamily: AppFonts.nunitoFontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        Expanded(child: Container()),
                        Text(
                          _formatTimestamp(comment.createdAt),
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: AppFonts.nunitoFontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: AppFonts.nunitoFontFamily,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.left,
                      comment.text,
                    ),
                  ]),
            );
          },
        ),
        SizedBox(height: 20,),
        TextButton(
          onPressed: () async {
          try {
            await NewsRepository().deleteComment(comment.newsId, comment.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Комментарий удален")),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Ошибка при удалении: $e")),
            );
          }
        },
          child: Container(
            width: 150,
            height: 56,
            decoration: BoxDecoration(
              color: const Color.fromARGB(123, 240, 49, 59),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                'Удалить',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
