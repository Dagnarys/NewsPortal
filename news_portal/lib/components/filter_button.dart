import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_portal/const/colors.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 6, // Отступ слева
      top: 130, // Отступ снизу
      child: Container(
        height: 28,
        width: 28,
    
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.all(Radius.circular(16))
        ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
             elevation: 0,
            onPressed: () {
              // Действие при нажатии на кнопку
              //добавить фильтр
            },
            child: SvgPicture.asset('assets/svg/filter.svg',color: Colors.white,) // Иконка кнопки
          ),
        ),
      );
  }
}