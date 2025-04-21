import 'package:flutter/material.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/user.dart';
import 'package:news_portal/screens/screen_auth.dart';
import 'package:provider/provider.dart';

class ScreenProfile extends StatelessWidget {
  ScreenProfile({super.key});
  final UserRepository _userRepository = UserRepository(); // Экземпляр репозитория

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
  // Проверяем, есть ли userId
  if (userProvider.userId == null) {
    return ScreenAuth();
  }

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userRepository.getUserDetails(userProvider.userId!), // Получаем данные пользователя
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Показываем индикатор загрузки
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Показываем сообщение об ошибке
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // Отображаем данные пользователя
            final userData = snapshot.data!;
            return Column(
              children: [
                TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: userData.containsKey('imageUrl')
                              ? NetworkImage(userData['imageUrl'])
                              : null,
                          child: userData.containsKey('imageUrl')
                              ? null
                              : Icon(Icons.person, size: 50),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '${userData['name']} ${userData['surname']}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Email: ${userData['email']}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Телефон: ${userData['phoneNumber']}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    userProvider.signOut(context);
                  },
                  child: Container(
                    width: 200,
                    height: 50,
                    child: Center(child: Text('Выйти')),
                  ),
                ),
                NavBar(),
              ],
            );
          } else {
            // Если данные не найдены
            return Center(child: Text('Пользователь не найден'));
          }
        },
      ),
    );
  }
}