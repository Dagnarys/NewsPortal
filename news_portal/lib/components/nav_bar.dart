import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/providers/user_provider.dart';
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
        widthFactor: 74,
        alignment: Alignment.centerLeft,
        child: Container(
          width: 74,
          height: 650,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 11,
                offset: Offset(0, 4),
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
                onPressed: () {
                  context.go('/web-news');
                },
                icon: SvgPicture.asset('assets/svg/news.svg'),
              ),
              IconButton(
                onPressed: () {
                  context.goNamed('pending-news');
                },
                icon: SvgPicture.asset('assets/svg/list.svg'),
              ),
              IconButton(
                onPressed: () {
                  context.go('/web-profile');
                },
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
                  context.goNamed('mobile-news');
                },
                icon: SvgPicture.asset('assets/svg/news.svg'),
              ),
              IconButton(
                onPressed: () {
                  context.push('/add');
                },
                icon: SvgPicture.asset('assets/svg/add.svg'),
              ),
              IconButton(
                onPressed: () {
                  context.go('/profile');
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
                  context.go('/');
                },
                icon: SvgPicture.asset('assets/svg/news.svg'),
              ),
              IconButton(
                onPressed: () {
                  context.go('/auth');
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
