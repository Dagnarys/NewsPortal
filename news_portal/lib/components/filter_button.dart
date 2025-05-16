import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_portal/components/news_stream.dart';
import 'package:news_portal/const/colors.dart';
class FilterButton extends StatelessWidget {
  final Function(SortOption, bool) onSortSelected;

  const FilterButton({super.key, required this.onSortSelected});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 6,
      top: 130,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: PopupMenuButton<SortOption>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: SortOption.newest,
              child: Text('Сначала новые'),
            ),
            PopupMenuItem(
              value: SortOption.oldest,
              child: Text('Сначала старые'),
            ),
            PopupMenuItem(
              value: SortOption.mostViews,
              child: Text('Больше просмотров'),
            ),
            PopupMenuItem(
              value: SortOption.leastViews,
              child: Text('Меньше просмотров'),
            ),
          ],
          onSelected: (value) {
            bool isAscending = false;
            if (value == SortOption.leastViews) isAscending = true;
            onSortSelected(value, isAscending);
          },
          child: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/svg/filter.svg',
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}