import 'package:flutter/material.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/repositories/news.dart';

class ScreenNew extends StatelessWidget {
  final String newsId;
  final NewsRepository repositoryNews = NewsRepository();
  ScreenNew({super.key, required this.newsId, });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TopBar(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(16),
                    child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '25 октября 2024',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Инженер – это множественное число',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Автор текста: Марина Ткачева',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    '#категория #категория',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Spacer(),
                  Text(
                    '© 1234',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Дискуссия «Университеты: как раскрыть потенциал обучающихся в эпоху технологий» состоялась 25 октября на площадке СберУниверситета. Участники обсудили, как готовить выпускников, способных управлять технологиями на благо, что ещё критически важно в образе их создателя, как эффективнее реализовать новые смыслы в образовательных программах. В обсуждении принял участие проректор по науке и цифровому развитию МГТУ им. Н.Э. Баумана Павел Дроговоз. Модератором дискуссии выступил руководитель центра по работе с вузами и академическим сообществом СберУниверситета Дмитрий Коваленко.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Как известно, высшая школа играет важнейшую роль в формировании собственного Я, закладывает фундамент дальнейшего образования и постоянного стремления к саморазвитию, самосовершенствованию. В своём выступлении Павел Дроговоз говорил о том, как в Бауманском университете смотрят на будущее и воспитывают инженеров, которым и предстоит его создавать своими руками.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                '«Для нас будущее уже наступило, — полушутя отметил проректор. — 2030 год для нас уже реален: мы набрали тех, кто выйдет в индустрию в тридцатом году».',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              SizedBox(
                    height: 150, // Задайте нужную высоту
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: [
                        // Ваши элементы списка
                        Container(
                          width: 100,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 100,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 100,
                          color: Colors.green,
                        ),
                        SizedBox(width: 10,),
                         // Ваши элементы списка
                        Container(
                          width: 100,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: 100,
                          color: Colors.blue,
                        ),SizedBox(width: 10,),
                        Container(
                          width: 300,
                          color: Colors.green,
                        ),
                      ],
                    ),
                    )],
                    ),
                  ),
          ),
        ],
      ),
    );
  }


}
