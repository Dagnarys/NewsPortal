// routes/mobile_routes.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/screens/screen_add.dart';
import 'package:news_portal/screens/screen_auth.dart';
import 'package:news_portal/screens/screen_category.dart';
import 'package:news_portal/screens/screen_comment.dart';
import 'package:news_portal/screens/screen_new.dart';

import 'package:news_portal/screens/screen_news_main.dart';
import 'package:news_portal/screens/screen_profile.dart';

final List<RouteBase> mobileRoutes = [
  GoRoute(
    path: '/',
    name: 'mobile-news',
    builder: (context, state) {
      // final Map<String, dynamic>? data = state.extra as Map<String, dynamic>?;
      // final String categoryId = data?['categoryId'] ?? '';
      // final String searchQuery = data?['searchQuery'] ?? '';
      final String categoryId = state.uri.queryParameters['categoryId'] ?? '';
    final String searchQuery = state.uri.queryParameters['searchQuery'] ?? '';
      return MainScreen(
        searchQuery: searchQuery,
        selectedCategoryId: categoryId,
      );
    },
  ),
  GoRoute(
    path: '/new/:id',
    name: 'news-detail',
    builder: (context, state) {
      final String newsId = state.pathParameters['id']!;
      print("Получен ID: $newsId");
      return ScreenNew(newsId: newsId);
    },
  ),
  GoRoute(
      path: '/auth',
      name: 'mobile-auth',
      builder: (context, state) {
        return ScreenAuth();
      }),
  GoRoute(
      path: '/profile',
      name: 'mobile-profile',
      builder: (context, state) {
        return ScreenProfile();
      }),
  GoRoute(
      path: '/add',
      name: 'mobile-add',
      builder: (context, state) {
        return ScreenAdd();
      }),
  GoRoute(
      path: '/category',
      name: 'mobile-category',
      builder: (context, state) {
        return ScreenCategory();
      }),
  GoRoute(
    path: '/mobile-news-comment',
    name: 'mobile-news-comment',
    builder: (context, state) {
      final Map<String, dynamic>? data = state.extra as Map<String, dynamic>?;
      final String newsId = data?['id'] ?? '';
      final String title = data?['title'] ?? '';

      if (newsId.isEmpty) {
        // Можно показать ошибку или вернуть предыдущий экран
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ошибка: Новость не найдена")),
        );
        return Container();
      }

      return ScreenComment(newsId: newsId, title: title);
    },
  ),
];
