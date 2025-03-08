import 'package:flutter/material.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components/top_bar.dart';

class ScreenCategory extends StatelessWidget {
  const ScreenCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      child:  Column(
        children: [
          TopBar(),
          Expanded(child: Container()),
          NavBar()
        ]
      ),
    );
  }
}