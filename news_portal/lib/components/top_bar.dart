import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_portal/components/hamburger_widget.dart';
import 'package:news_portal/components/search_widget.dart';
import 'package:news_portal/const/colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Align(
        child: Container(
          color: Colors.white,
          width: 345,
          height: 40,
          
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (ModalRoute.of(context)?.canPop ?? false)
                Container(
                  width: 40,
                  height: 40,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset('assets/svg/back.svg'),
                  ),
                ),
              const SearchWidget(),
              const HamburgerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
