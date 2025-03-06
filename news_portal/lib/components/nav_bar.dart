import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBar extends StatelessWidget {
  final String role = 'user';
  const NavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (role == 'moderator')
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 74,
                  height: 650,
                  decoration: const BoxDecoration(
                      boxShadow: [BoxShadow(
                        color: Colors.black, // Цвет тени с прозрачностью
                        spreadRadius: 2, // Радиус размытия
                        blurRadius: 10, // Радиус тени
                        offset: Offset(4, 4), // Смещение тени по x и y
                      )],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(32))),
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
                      )
                    ],
                  ),
                )),
          )
        else if (role != 'moderator')
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: role == 'user' ? 175 : 135,
                height: 58,
                decoration: const BoxDecoration(
                    boxShadow: [BoxShadow(
                        color: Color.fromARGB(75, 0, 0, 0), // Цвет тени с прозрачностью
                        blurRadius: 11, // Радиус тени
                        offset: Offset(0, 4), // Смещение тени по x и y
                      )],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(32))),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: role == 'user'
                        ? [
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('assets/svg/news.svg'),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('assets/svg/add.svg'),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('assets/svg/profile.svg'),
                            )
                          ]
                        : [
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('assets/svg/news.svg'),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset('assets/svg/profile.svg'),
                            )
                          ]),
              ),
            ),
          )
      ],
    );
  }
}
