import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // для kIsWeb
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/firebase_options.dart';
import 'package:news_portal/providers/category_provider.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/categories.dart';
import 'package:news_portal/routes/mobile_routes.dart';
import 'package:news_portal/routes/web_routes.dart';
import 'package:provider/provider.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  final userProvider = UserProvider();
  await userProvider.loadCurrentUser();

    // Подписываемся на изменения сессии
  FirebaseAuth.instance.authStateChanges().listen((firebaseUser) async {
    if (firebaseUser != null) {
      await userProvider.loadCurrentUser();
    } else {
      userProvider.clearUser();
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider(CategoriesRepository())),
        ChangeNotifierProvider.value(value: userProvider),
      ],
      child: MyApp(),
    ),
  );
}
final _router = GoRouter(
  
  routes: kIsWeb || ![TargetPlatform.android, TargetPlatform.iOS].contains(defaultTargetPlatform)
      ? webRoutes
      : mobileRoutes,
);
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'News Portal',
    );
  }
}