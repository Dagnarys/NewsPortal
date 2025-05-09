import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/screens/screen_regisrty.dart';
import 'package:provider/provider.dart';
import 'package:news_portal/providers/user_provider.dart'; // Подключаем свой провайдер

class TopBarComment extends StatelessWidget {
   final TextEditingController commentController;
  final VoidCallback onSend;

  const TopBarComment({
    super.key,
    required this.commentController,
    required this.onSend,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Align(
        child: Container(
          width: 380,
          height: 40,
          child: Consumer<UserProvider>(
            builder: (context, provider, child) {
              if (provider.isGuest) {
                // Пользователь НЕ авторизован
                return Row(
                  children: [
                    if (ModalRoute.of(context)?.canPop ?? false)
                      Container(
                        padding: const EdgeInsets.only(right: 2),
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          gradient: AppColors.primaryGradient,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: SvgPicture.asset(
                            'assets/svg/back.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        // Переход на страницу входа / регистрации
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenRegistry()));
                      },
                      child: Text(
                        'Зарегистрируйтесь, чтобы прокомментировать',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.nunitoFontFamily),
                      ),
                    )
                  ],
                );
              } else {
                // Пользователь авторизован
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (ModalRoute.of(context)?.canPop ?? false)
                      Container(
                        padding: const EdgeInsets.only(right: 2),
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          gradient: AppColors.primaryGradient,
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: SvgPicture.asset(
                            'assets/svg/back.svg',
                            color: Colors.white,
                          ),
                        ),
                      ),
                    const SizedBox(width: 5),
                    // Поле ввода комментария
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Добавить комментарий...',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF818181),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              style: BorderStyle.solid,
                              color: AppColors.borderColor,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF456AE5),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF456AE5),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      padding: const EdgeInsets.only(right: 2),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        gradient: AppColors.primaryGradient,
                      ),
                      child: IconButton(
                        // Логика отправки комментария
                        onPressed: onSend,
                        icon: Icon(Icons.reply, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
