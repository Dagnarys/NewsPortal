import 'package:flutter/foundation.dart'; // для kIsWeb
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_portal/firebase_options.dart';
import 'package:news_portal/pages/page_news.dart';
import 'package:news_portal/providers/category_provider.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/categories.dart';
import 'package:news_portal/screens/screen_news_main.dart'; // MainScreen
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider(CategoriesRepository())),
        ChangeNotifierProvider(
          create: (_) {
            final provider = UserProvider();
            // ❗ Переносим loadCurrentUser() позже, если он использует Firebase
            // Например, вызываем его в initState главного экрана
            return provider;
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Определяем, какую страницу показать
    Widget homeScreen;

    if (kIsWeb || ![TargetPlatform.android, TargetPlatform.iOS].contains(defaultTargetPlatform)) {
      // Для веба и десктопа
      homeScreen = const MainPage(); 
    } else {
      // Для мобильных устройств
      homeScreen = const MainScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News Portal',
      home: homeScreen,
    );
  }
}