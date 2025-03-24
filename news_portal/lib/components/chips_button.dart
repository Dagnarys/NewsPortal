
import 'package:flutter/material.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/providers/category_provider.dart';
import 'package:news_portal/screens/screen_news_main.dart';
import 'package:provider/provider.dart';

class ChipsButton extends StatelessWidget {

  final String label;
  final VoidCallback? onPressed;
  final double fontSize;

  const ChipsButton({super.key, required this.label, this.onPressed, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: TextButton(
        onPressed: onPressed ??
          () async {
            // Получаем репозиторий категорий из провайдера
            final categoryRepo = Provider.of<CategoryProvider>(context, listen: false).repository;

            // Ищем категорию по имени
            final category = await categoryRepo.getCategoryByName(label);
            if (category != null) {
              // Переходим на главный экран с ID категории
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(selectedCategoryId: category.id),
                ),
                (route)=>false,

              );
            } else {
              print('Категория с именем $label не найдена');
          }
        },
        style: TextButton.styleFrom(
          minimumSize: Size(double.minPositive,double.minPositive),
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0), // Убираем стандартный padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.borderColor),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(4, 1, 5, 0),
          child: Text(
            '#$label',
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: AppFonts.nunitoFontFamily,
              color: Color(0xFF2E0505),
              decoration: TextDecoration.none,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
