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
      body: Stack(
        children: [
          CustomScrollView(
            scrollBehavior: ScrollBehavior(),
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                toolbarHeight: 0,
                collapsedHeight: 0,
                expandedHeight: 250.0,
                flexibleSpace:  Image.network(widget.image, fit: BoxFit.cover),
              ),
          
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                    color: Colors.black,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16,horizontal: 6),
                        alignment:AlignmentDirectional.centerStart,
                        width: 311,
                        height: 109,
                        decoration: BoxDecoration(
                          
                          color: Colors.amber
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Text(
                              '25 октября 2024',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.title,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Автор текста: Марина Ткачева',
                              style: TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Text(
                                  '#категория #категория',
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                                const Spacer(),
                                Text(
                                  '© 1234',
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ),
                    Container(                        
                      child: Text(
                        widget.content,
                        style: const TextStyle(fontSize: 16),
                                        ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: Column(children: [
                 
                      const SizedBox(height: 16),
                      const CarouselImages(),
                ],),
              )
            ],
          ),
          Positioned(
            top: 0,
            left:0,
            right: 0,
            child: TopBar(),),
        ],
      ),
    );
  }
}

