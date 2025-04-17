import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/screens/screen_auth.dart';
import 'package:news_portal/screens/screen_news_main.dart';
import 'package:news_portal/screens/screen_profile.dart';
import 'package:news_portal/screens/screen_regisrty.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Stack(
      children: [
        if (userProvider.isModerator)
          _buildModeratorPanel()
        else if (userProvider.isUser)
          _buildUserPanel()
        else
          _buildGuestPanel(),
      ],
    );
  }

// Методы для построения панелей
  Widget _buildModeratorPanel() {
    return Padding(
      padding: const EdgeInsets.only(left: 40),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 74,
          height: 650,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 2,
                blurRadius: 10,
                offset: Offset(4, 4),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/svg/news.svg'),
              ),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/svg/list.svg'),
              ),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/svg/profile.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserPanel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 175,
          height: 58,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(75, 0, 0, 0),
                blurRadius: 11,
                offset: Offset(0, 4),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                },
                icon: SvgPicture.asset('assets/svg/news.svg'),
              ),
              IconButton(
                onPressed: () {},
                icon: SvgPicture.asset('assets/svg/add.svg'),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ScreenProfile()),
                    (route) => false,
                  );
                },
                icon: SvgPicture.asset('assets/svg/profile.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestPanel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: 135,
          height: 58,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(75, 0, 0, 0),
                blurRadius: 11,
                offset: Offset(0, 4),
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                    (route) => false,
                  );
                },
                icon: SvgPicture.asset('assets/svg/news.svg'),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => ScreenAuth()),
                    (route) => false,
                  );
                },
                icon: SvgPicture.asset('assets/svg/profile.svg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
