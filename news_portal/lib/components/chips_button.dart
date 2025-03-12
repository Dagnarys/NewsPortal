
import 'package:flutter/material.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';

class ChipsButton extends StatelessWidget {

  final String label;
  final VoidCallback? onPressed;

  const ChipsButton({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
      child: TextButton(
        onPressed: onPressed ??() {
        },
        style: TextButton.styleFrom(
          minimumSize: Size(double.minPositive,double.minPositive),
          padding: const EdgeInsets.all(0), // Убираем стандартный padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.borderColor),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(3, 1, 3, 2),
          child: Text(
            '#$label',
            style: TextStyle(
              fontFamily: AppFonts.nunitoFontFamily,
              color: Colors.black,
              decoration: TextDecoration.none,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
