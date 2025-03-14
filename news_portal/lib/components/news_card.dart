import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_portal/fonts/fonts.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(8, 55, 8, 8),
        width: 321,
        height: 205,
        
        decoration: BoxDecoration(
          image:DecorationImage(image: NetworkImage('https://downloader.disk.yandex.ru/preview/190e43a026c3ea934a08bb1b5ab73a1b6a93d59b210ae191d677958a8d86203a/67d4af9d/Wyyw8bpFhq8nDv_t4lp8psXsfcWgY1eLAQ_TRC8Is9LtQgp9ua0x_mAaf3VHifgM6svxM_Fu1a4VrBAiz6LWiA%3D%3D?uid=0&filename=image_card.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&owner_uid=0&tknv=v2&size=2048x2048'),
          fit: BoxFit.cover,),
          // color: const Color.fromARGB(255, 6, 6, 6),
          borderRadius: BorderRadius.all(Radius.circular(16))
      
        ),
        child: Column(
          children: [
            Text(
              style: TextStyle(
                fontSize: 18,
                fontFamily: AppFonts.nunitoSansFontFamily,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              'Инженер - это множественное число '
            ),
            SizedBox(height: 26,),
            Text(
              'Для нас будущее уже наступило, — полушутя отметил проректор. — 2030 год для нас уже реален: мы набрали тех, кто выйдет в индустрию в тридцатом году',
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunitoFontFamily,
                color: Colors.white)
                ),
            Expanded(child: Container()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                '#категория #категория',
                style: TextStyle(
                fontSize: 12,
                fontFamily: AppFonts.nunitoFontFamily,
                color: Colors.white
              ),),
              Row(
                children: [
                   SvgPicture.asset(
                    'assets/svg/comment.svg',
                  ),
                  SizedBox(width: 2,),
                  Text(
                    '1234',
                     style: TextStyle(
                      fontSize: 10,
                      fontFamily: AppFonts.nunitoFontFamily,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB3B3B3)
                    )
                  ) , 
                  SizedBox(width: 4,),
                  SvgPicture.asset(
                    'assets/svg/eye.svg',
                  ),
                  SizedBox(width: 2,),
                  Text(
                    '1234',
                     style: TextStyle(
                    fontSize: 10,
                    fontFamily: AppFonts.nunitoFontFamily,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB3B3B3)
                    )
                  ) ,      
                ],
              ),
        
              ],
            )
          ],
        ),
      
      ),
    );
  }
}