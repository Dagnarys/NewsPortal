import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:news_portal/components/carousel_images_gallery.dart';
import 'package:news_portal/components/top_bar.dart';
import 'package:news_portal/models/model_categories.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/repositories/categories.dart';
import 'package:news_portal/repositories/news.dart';

class ScreenNew extends StatefulWidget {
  final String newsId;

  const ScreenNew({super.key, required this.newsId});

  @override
  State<ScreenNew> createState() => _ScreenNewState();
}

class _ScreenNewState extends State<ScreenNew> {
  late Future<News> _newsFuture;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _newsFuture = NewsRepository().getNewsById(widget.newsId);
    NewsRepository().incrementViewCount(widget.newsId);
  }

  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      context.go('/',
          extra: {'categoryId': null, 'searchQuery': value.toLowerCase()});
    }
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return '${date.day}.${date.month}.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Место для верхнего изображения
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FutureBuilder<News>(
              future: _newsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: 261,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final news = snapshot.data!;
                final imageUrl =
                    news.imageUrls.isNotEmpty ? news.imageUrls.first : '';

                return imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 261,
                      )
                    : Container(
                        height: 261,
                        color: Colors.grey[300],
                        child: Center(child: Text('Изображений нет')),
                      );
              },
            ),
          ),

          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                toolbarHeight: 40,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: TopBar(
                  searchController: _searchController,
                  onSubmitted: _onSearchSubmitted,
                ),
                titleSpacing: 0,
                centerTitle: false,
                excludeHeaderSemantics: true,
                title: const SizedBox.shrink(),
                leading: const SizedBox.shrink(),
                actions: const [],
              ),
              SliverToBoxAdapter(
                child: FutureBuilder<News>(
                  future: _newsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Ошибка: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Center(child: Text('Новость не найдена'));
                    }

                    final news = snapshot.data!;

                    return Container(
                      padding: EdgeInsets.only(top: 135),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 40),
                                padding:
                                    EdgeInsets.only(top: 90, right: 4, left: 4),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  news.content,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 6),
                                  alignment: AlignmentDirectional.centerStart,
                                  width: 311,
                                  height: 109,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                    color: Color.fromRGBO(214, 212, 212, 0.979),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatDate(news.publishedAt),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF2E0505)),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        news.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2E0505),
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        news.authorName,
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF2E0505)),
                                      ),
                                      SizedBox(height: 3),
                                      Row(
                                        children: [
                                          FutureBuilder<Category?>(
                                            future: CategoriesRepository()
                                                .getCategory(news.categoryId),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text('#загрузка');
                                              } else if (snapshot.hasError ||
                                                  !snapshot.hasData ||
                                                  snapshot.data == null) {
                                                return Text('#ошибка');
                                              } else {
                                                return Text(
                                                  '#${snapshot.data!.name}',
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Color(0xFF2E0505)),
                                                );
                                              }
                                            },
                                          ),
                                          Spacer(),
                                          SvgPicture.asset(
                                            color: Color(0xFF2E0505),
                                            'assets/svg/eye.svg',
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          Text(
                                            '${news.viewCount}',
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF2E0505)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: FutureBuilder<News>(
                  future: _newsFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SizedBox();
                    }

                    final news = snapshot.data!;
                    return news.imageUrls.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(height: 16),
                              CarouselImages(imageUrls: news.imageUrls),
                              SizedBox(height: 35),
                            ],
                          )
                        : SizedBox();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
