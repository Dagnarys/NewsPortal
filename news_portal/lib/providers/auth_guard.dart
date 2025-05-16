import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AuthGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final authProvider = context.read<UserProvider>();
    final isProtectedRoute = state.uri.toString().startsWith('/web-news') || 
                            state.uri.toString().startsWith('/web-profile');

    if (!authProvider.isAuthenticated && isProtectedRoute) {
      return '/'; // Редирект на главную
    }
    
    if (authProvider.isAuthenticated && state.uri.toString() == '/') {
      return '/web-news'; // Автоматический переход к новостям
    }
    
    return null;
  }
}