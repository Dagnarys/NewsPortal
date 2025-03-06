import 'package:flutter/material.dart';

class AppColors {
  // Основные цвета
  static const Color primaryColor = Color(0xFF456AE5);
  static const Color accentColor = Color(0xFFFF8086);
  static const Color borderColor = Color(0xFF4E5CE0);
  // Градиенты
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, accentColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}