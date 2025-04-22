import 'package:flutter/material.dart';
import 'package:news_portal/components/carousel_images_gallery.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/repositories/news.dart';

class ScreenNew extends StatefulWidget {
  final String newsId;
  final NewsRepository repositoryNews = NewsRepository();
  final String title;
  final String content;
  final String image;

  ScreenNew({
    super.key,
    required this.newsId,
    required this.content,
    required this.title,
    required this.image,
  });

  @override
  State<ScreenNew> createState() => _ScreenNewState();
}

class _ScreenNewState extends State<ScreenNew> {
  final ScrollController _scrollController = ScrollController();
  bool _showCollapsedTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final offset = _scrollController.offset;
    setState(() {
      _showCollapsedTitle = offset > 100;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left:0,
            right: 0,
            child: Image.network(widget.image, fit: BoxFit.cover, width: 383, height: 261,),),
          
          CustomScrollView(
            scrollBehavior: ScrollBehavior(),
            controller: _scrollController,
            slivers: [    
                        SliverAppBar(
                pinned: true,
                toolbarHeight: 40,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: const TopBar(),
                titleSpacing: 0,
                centerTitle: false,
                excludeHeaderSemantics: true,
                title: const SizedBox.shrink(),
                leading: const SizedBox.shrink(),
                actions: const [],
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.only(top: 135),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(children: [
                        Container(   
                          
                          margin: EdgeInsets.only(top: 25),
                          padding: EdgeInsets.only(top: 90,right: 4,left: 4) ,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            color: Colors.white,
                          ),
                        child: Text(
                          
                          widget.content,
                          style: const TextStyle(fontSize: 16),
                                          ),
                      ),
                        Center(
                        
                          child: Container(
                            
                            padding: EdgeInsets.symmetric(vertical: 16,horizontal: 6),
                            alignment:AlignmentDirectional.centerStart,
                            width: 311,
                            height: 109,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                              color: Color.fromRGBO(214, 212, 212, 0.979)
                            ),
                            child: Container(
                              
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  
                                  Text(
                                    '25 октября 2024',
                                    style: TextStyle(fontSize: 12, color: Color(0xFF2E0505)),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    widget.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Color(0xFF2E0505)),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'Автор текста: Марина Ткачева',
                                    style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600, color: Color(0xFF2E0505)),
                                  ),
                                  const SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Text(
                                        '#категория',
                                        style: TextStyle(fontSize: 10, color: Color(0xFF2E0505)),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '© 1234',
                                        style: TextStyle(fontSize: 10, color: Color(0xFF2E0505)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      
                      

                      ],)
                      
                      
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Column(children: [
                   
                        const SizedBox(height: 16),
                        const CarouselImages(),
                        const SizedBox(height: 35),
                  ],),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

