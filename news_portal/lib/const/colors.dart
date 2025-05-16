import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета
  static const Color primaryColor = Color(0xFF456AE5);
  static const Color accentColor = Color(0xFFFF8086);
  static const Color borderColor = Color(0xFF4E5CE0);
  static const Color buttonColorTop = Color(0xFF105CBC);
  // Градиенты
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient redwhiteGradient = LinearGradient(
    colors: [Colors.red,Color(0xFFBCC4CE) ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
    static const LinearGradient buttonGradient = LinearGradient(
    colors: [buttonColorTop, Color(0xFFBCC4CE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

}