import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_portal/const/colors.dart';

class HamburgerWidget extends StatelessWidget {
  const HamburgerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        gradient: AppColors.primaryGradient,
      ),
      width: 40,
      
      height: 40,
      child: IconButton(     
        
        onPressed: (){},
        icon:  SvgPicture.asset(
          'assets/svg/hamburger.svg',
          )),
    );
  }
}