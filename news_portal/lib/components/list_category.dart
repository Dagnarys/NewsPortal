import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:news_portal/components/chips_button.dart';
import 'package:news_portal/const/colors.dart';

class ListCategory extends StatelessWidget {
  const ListCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 13, 10,13),
        decoration:  const BoxDecoration(
          border: GradientBoxBorder(
            gradient: AppColors.primaryGradient,
            
          ),
          borderRadius:BorderRadius.all( Radius.circular(16))
        ),
        width: 373,
        // color: Colors.amber,
        child: const ChipsList()
        ),
    );
  }
}

class ChipsList extends StatelessWidget {
  const ChipsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: List<Widget>.generate(20, (index) => ChipsButton()),
    );
  }
}
