import 'package:flutter/material.dart';
import 'package:news_portal/const/colors.dart';
class SearchWidgetWeb extends StatelessWidget {
   final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  const SearchWidgetWeb({
    required this.controller,
    required this.onSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Material(
        
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1300,
              minWidth: 50,
              maxHeight: 40,
            ),
            
            child:  TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              style: TextStyle(
                fontSize: 20,
              ),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Поиск...',
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF818181),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    color: AppColors.borderColor,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF456AE5),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF456AE5),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
