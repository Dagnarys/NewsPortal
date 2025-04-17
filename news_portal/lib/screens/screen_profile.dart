import 'package:flutter/material.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ScreenProfile extends StatelessWidget {
  ScreenProfile({super.key});
  

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return  Container(
      color: Colors.white,
      child:  Column(
        children: [
          TopBar(),
          Expanded(child: Container(
          )),
          Text('профиль'),
          ElevatedButton(onPressed: (){
            userProvider.signOut(context);
          }
            ,child: Container(width: 200,height: 200,child: Center(child: Text('Выйти'))),),
          NavBar()
        ]
      ),
    );
  }
}