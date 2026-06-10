import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPink = Color(0xFFFF69B4); // Hot Pink
  static const Color softPink = Color(0xFFFFB6C1); // Light Pink
  static const Color deepPink = Color(0xFFC71585); // Medium Violet Red
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8F8F8);
  static const Color charcoal = Color(0xFF333333);
  static const Color gold = Color(0xFFFFD700);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.charcoal,
  );

  static const TextStyle subHeading = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.deepPink,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.charcoal,
  );

  static const TextStyle price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.deepPink,
  );
}

class AppConfig {
  static const String currency = 'Kshs';
}
