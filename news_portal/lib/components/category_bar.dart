import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_portal/components/chips_button.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/screens/screen_category.dart';

class CategoryBar extends StatelessWidget {
  const CategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 348,
      height: 24,
      //ниже обводка бара с категориями
      // decoration:  BoxDecoration(
      //   border: Border.all(
      //     // color: Colors.red,
      //     // width: 2,
      //   )
      // ),
      child: Row(
        children: [
          //пару чипсов, переход фильтрация по категории
          const ChipsButton(),
          const ChipsButton(),
          const ChipsButton(),
          Expanded(
            child: Container(),
          ),
          //кнопка перехода на screen_category
          const CategoryButton(),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  const CategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ScreenCategory()));
        },
        child: Container(
          alignment: Alignment.center,
          width: 58,
          height: 18,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                child: Text(
                  'все #',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppFonts.nunitoFontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              
              SvgPicture.asset('assets/svg/arrow_category.svg',width: 10,height: 12,),
            ],
          ),
        ));
  }
}
