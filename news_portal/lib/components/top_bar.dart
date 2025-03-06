import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
              Container(
                width: 40,
                height: 40,
                child: IconButton(     
                  onPressed: (){},
                  icon:  SvgPicture.asset(
                    'assets/svg/back.svg',
                    )),
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
class SearchWidget extends StatelessWidget {
  const SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 216,
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
    );
  }
}
