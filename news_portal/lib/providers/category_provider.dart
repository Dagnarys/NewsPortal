import 'package:flutter/material.dart';
import 'package:news_portal/repositories/categories.dart';

class CategoryProvider with ChangeNotifier {
  final CategoriesRepository repository;

  CategoryProvider(this.repository);
}