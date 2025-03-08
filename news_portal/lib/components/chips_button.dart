
import 'package:flutter/material.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/screens/screen_category.dart';

class ChipsButton extends StatelessWidget {
  const ChipsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero, // Убираем стандартный padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderColor),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(3, 1, 3, 2),
        child: Text(
          '#студентам',
          style: TextStyle(
            fontFamily: AppFonts.nunitoFontFamily,
            color: Colors.black,
            decoration: TextDecoration.none,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
