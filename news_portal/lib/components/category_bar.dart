import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_portal/components/chips_button.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/models/model_categories.dart';
import 'package:news_portal/repositories/categories.dart';
import 'package:news_portal/screens/screen_category.dart';

class CategoryBar extends StatefulWidget {
  const CategoryBar({super.key});

  @override
  State<CategoryBar> createState() => _CategoryBarState();
}

class _CategoryBarState extends State<CategoryBar> {
  final CategoriesRepository _repositoryCategory = CategoriesRepository();
  List<Category> _allCategories = [];
  List<Category> _randomCategories = [];

  @override
  void initState() {
    super.initState();
    _repositoryCategory.getCategories().listen((categories) {
      setState(() {
        _allCategories = categories;
        _randomCategories = _getUniqueRandomCategories(2);
      });
    });
  }

  List<Category> _getUniqueRandomCategories(int count) {
    if (_allCategories.isEmpty) return [];
    final shuffledCategories = List.of(_allCategories)..shuffle();

    return shuffledCategories.take(count).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 24,
      child: Row(
        children: [
          // Случайные категории
          if (_randomCategories.isNotEmpty)
            ..._randomCategories.map((category) => Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: ChipsButton(
                    fontSize: 14,
                    label: category.name,
                  ),
                )),
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
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Container(
          width: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.primaryGradient.createShader(bounds),
                child: Text(
                  'все #',
                  style: TextStyle(
                      fontFamily: AppFonts.nunitoFontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SvgPicture.asset(
                'assets/svg/arrow_category.svg',
                width: 10,
                height: 12,
              ),
            ],
          ),
        ));
  }
}
