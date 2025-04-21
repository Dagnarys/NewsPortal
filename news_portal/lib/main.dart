import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_portal/firebase_options.dart';
import 'package:news_portal/providers/category_provider.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/categories.dart';
import 'package:news_portal/screens/screen_news_main.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider(CategoriesRepository())),
        ChangeNotifierProvider(create: (_) {
          final provider = UserProvider();
          provider.loadCurrentUser(); // Загружаем данные текущего пользователя
          return provider;
        }),
      ],
      child: MyApp(),
    ),);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(), 
    );
  }
}
