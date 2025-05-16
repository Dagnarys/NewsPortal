import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/components/search_widget.dart';
import 'package:news_portal/const/colors.dart';

class TopBar extends StatelessWidget {
    final TextEditingController searchController;
  final ValueChanged<String> onSubmitted;
  const TopBar({
    super.key,
    required this.searchController,
    required this.onSubmitted,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Align(
        child: Container(
          // color: Colors.white,
          width: 380,
          height: 40,
          
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (ModalRoute.of(context)?.canPop ?? false)
                Container(
                  padding: EdgeInsets.only(right: 2),
                  width: 40,
                  
                  height: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    gradient: AppColors.primaryGradient,
                  ),
                  child: IconButton(
                    onPressed: () {
                      context.pop('/');
                    },
                    icon: SvgPicture.asset('assets/svg/back.svg',color: Colors.white,),
                  ),
                ),
              SearchWidget(
                controller: searchController,
                onSubmitted: onSubmitted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
