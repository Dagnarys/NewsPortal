import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:news_portal/components/chips_button.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/models/model_categories.dart';
import 'package:news_portal/repositories/categories.dart';

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
class ChipsList extends StatefulWidget {
  const ChipsList({super.key});

  @override
  State<ChipsList> createState() => _ChipsListState();
}

class _ChipsListState extends State<ChipsList> {
  final CategoriesRepository _repository = CategoriesRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Category>>(
      stream: _repository.getCategories(),
      builder: (context, snapshot) {
        //проверка на ожидание,если ждем показываем иконку загрузки
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        //проверка на загрузку данных
        if (snapshot.hasError) {
          return Center(
            child: Text('Ошибка: ${snapshot.error}'),
          );
        }

        final categories = snapshot.data ?? [];
        //если в бд категорий нет
        if (categories.isEmpty) {
          return const Center(child: Text('Категорий нет'));
        }

        return Wrap(
          spacing: 8,
          runSpacing: 8.0,
          //превращаем категории в лист чипсов
          children: categories.map((category) {
            return ChipsButton(label: category.name,fontSize: 18,);
          }).toList(),
        );
      },
    );
  }
}
