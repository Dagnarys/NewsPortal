import 'package:flutter/material.dart';
import 'package:news_portal/const/colors.dart';
class SearchWidget extends StatelessWidget {
  const SearchWidget({
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
              maxWidth: 280,
              minWidth: 50,
              maxHeight: 32,
            ),
            
            child: const TextField(
              style: TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Поиск...',
                hintStyle: TextStyle(
                  fontSize: 12,
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
