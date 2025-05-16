// screen_comment.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_portal/components/comment_card.dart';
import 'package:news_portal/components/top_bar_comment.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/models/model_comment.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/news.dart';
import 'package:provider/provider.dart';

class ScreenComment extends StatefulWidget {
  final String newsId; // Принимаем ID новости
  final String title;
  const ScreenComment({super.key, required this.newsId, required this.title});

  @override
  State<ScreenComment> createState() => _ScreenCommentState();
}

class _ScreenCommentState extends State<ScreenComment> {
  late Stream<List<Comment>> _commentsStream;
  final TextEditingController _commentController = TextEditingController();
  final NewsRepository _newsRepo = NewsRepository();
  @override
  void initState() {
    super.initState();
    _commentsStream = _newsRepo.getCommentsStream(widget.newsId);
  }
  @override
  void dispose() {
    _commentController.dispose(); // Очищаем контроллер
    super.dispose();
  }

  

  void _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Авторизуйтесь, чтобы оставить комментарий")),
      );
      return;
    }

    
final newComment = Comment(
  id: '',
  newsId: widget.newsId,
  userId: userProvider.userId ?? 'unknown',
  text: _commentController.text,
  createdAt: Timestamp.now(),
  userName: userProvider.userFirstName,
  userSurname: userProvider.userLastName,
);

    await _newsRepo.addCommentToNews(widget.newsId, newComment);

    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Верхняя панель
            TopBarComment(
              commentController: _commentController,
              onSend: _submitComment, // <-- Передаем логику отправки
            ),
            const SizedBox(height: 5),

            // Заголовок новости
            Container(
              alignment: Alignment.center,
              width: 344,
              constraints: const BoxConstraints(minHeight: 29),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: AppColors.primaryColor),
              ),
              child: Text(
                textAlign: TextAlign.center,
                maxLines: 2,
                widget.title, // Можно заменить на динамический текст
                style: TextStyle(
                  fontFamily: AppFonts.nunitoFontFamily,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Color(0xFF332C2C),
                ),
              ),
            ),

            const SizedBox(height: 5),

            // Список комментариев
            Expanded(
              child: StreamBuilder<List<Comment>>(
                stream: _commentsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Нет комментариев'));
                  } else {
                    final comments = snapshot.data!;
                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(10,0,10,20),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return CommentCard(comment: comments[index]);
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 12,),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
