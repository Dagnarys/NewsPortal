// routes/web_routes.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/pages/page_auth.dart';
import 'package:news_portal/pages/page_check.dart';
import 'package:news_portal/pages/page_comment.dart';
import 'package:news_portal/pages/page_edit.dart';
import 'package:news_portal/pages/page_new.dart';
import 'package:news_portal/pages/page_news.dart';
import 'package:news_portal/pages/page_pending.dart';
import 'package:news_portal/pages/page_profile.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:provider/provider.dart';

final List<RouteBase> webRoutes = [
  GoRoute(
    path: '/',
    name: 'web-auth',
    builder: (context, state) => const PageAuth(),
  ),
  GoRoute(
      path: '/web-news',
      name: 'web-news',
      builder: (context, state) {
        final String categoryId = state.uri.queryParameters['categoryId'] ?? '';
        final String searchQuery =
            state.uri.queryParameters['searchQuery'] ?? '';
        return MainPage(
          searchQuery: searchQuery,
          selectedCategoryId: categoryId,
        );
      },
      redirect: (context, state) {
        final authProvider = context.read<UserProvider>();
        if (!authProvider.isAuthenticated) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/:id',
          name: 'web-news-detail',
          builder: (context, state) {
            final String newsId = state.pathParameters['id']??'';
            print("Получен ID: $newsId");
            return PageNew(newsId: newsId);
          },
        ),
        GoRoute(
          path: '/:id/comments',
          name: 'web-news-comment',
          builder: (context, state) {
            final String newsId = state.pathParameters['id']!;
            print("Получен ID: $newsId");
            return PageComment(newsId: newsId);
          },
        ),
      ]),
  GoRoute(
    path: '/web-profile',
    name: 'web-profile',
    builder: (context, state) => const PageProfile(),
  ),
  GoRoute(
      path: '/pending-news',
      name: 'pending-news',
      builder: (context, state) => const PendingNewsPage(),
      routes: [
        GoRoute(
          path: '/check/:id',
          name: 'pending-news.check',
          builder: (context, state) {
            final newsId = state.pathParameters['id']!;
            return CheckNewsPage(newsId: newsId);
          },
        ),
      ]),
  GoRoute(
    path: '/news-edit/:id',
    name: 'news-edit',
    builder: (context, state) {
      final newsId = state.pathParameters['id']!;
      return PageEdit(
        newsId: newsId,
      );
    },
  ),
];
