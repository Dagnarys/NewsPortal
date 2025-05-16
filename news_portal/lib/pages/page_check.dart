import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:news_portal/components/nav_bar.dart';
import 'package:news_portal/components_web/carousel_images_web.dart';
import 'package:news_portal/components_web/search_widget_web.dart';
import 'package:news_portal/const/colors.dart';
import 'package:news_portal/fonts/fonts.dart';
import 'package:news_portal/models/model_news.dart';
import 'package:news_portal/providers/user_provider.dart';
import 'package:news_portal/repositories/news.dart';
import 'package:provider/provider.dart';

class CheckNewsPage extends StatefulWidget {
  final String newsId;
  const CheckNewsPage({super.key, required this.newsId});

  @override
  State<CheckNewsPage> createState() => _CheckNewsPageState();
}

class _CheckNewsPageState extends State<CheckNewsPage> {
  final TextEditingController _searchController = TextEditingController();
  late final NewsRepository repositoryNews;
  News? _currentNews;
  void _onSearchSubmitted(String value) {
    if (value.isNotEmpty) {
      context.goNamed('web-news', queryParameters: {'searchQuery': value});
    }
  }

  @override
  void initState() {
    super.initState();
    repositoryNews = NewsRepository();
    _loadNews();
  }

  Future<void> _loadNews() async {
    final news = await repositoryNews.getNewsById(widget.newsId);
    setState(() {
      _currentNews = news;
    });
  }

  Future<void> _approveNews() async {
    await repositoryNews.updateNewsStatus(widget.newsId, 'approved');
    context.pop(); // Возврат на предыдущую страницу
  }

  Future<void> _rejectNews() async {
    await repositoryNews.updateNewsStatus(widget.newsId, 'rejected');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: GradientBoxBorder(gradient: AppColors.primaryGradient)
          ),
          child: Stack(children: [
            NavBar(),
            // Поисковая панель
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Positioned.fill(
                  top: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchWidgetWeb(
                        controller: _searchController,
                        onSubmitted: _onSearchSubmitted,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          userProvider.signOutWeb(context);
                        },
                        child: Container(
                          width: 120, // Совпадает с width у Positioned
                          height: 50, // Совпадает с height у Positioned
                          decoration: BoxDecoration(
                            gradient: AppColors.redwhiteGradient,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Text(
                              'Выйти',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Проверка новости',
                  style: TextStyle(
                      fontFamily: AppFonts.nunitoFontFamily,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 1400,
                  height: 700,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                      border:
                          GradientBoxBorder(gradient: AppColors.primaryGradient)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        _currentNews!.title,
                        style: TextStyle(
                            fontFamily: AppFonts.nunitoFontFamily,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: CustomScrollView(slivers: [
                          SliverToBoxAdapter(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _currentNews!.content,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                          SliverToBoxAdapter(
                              child: Column(
                            children: [
                              SizedBox(height: 16),
                              CarouselImagesWeb(imageUrls: _currentNews!.imageUrls),
                              SizedBox(height: 35),
                            ],
                          )),
                          SliverToBoxAdapter(
                              child: Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    _approveNews();
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.buttonGradient,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Опубликовать',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: () {
                                    _rejectNews();
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.redwhiteGradient,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Отклонить',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ]),
                      )
                    ],
                  ),
                )
              ],
            ),
          ]),
        ));
  }
}
