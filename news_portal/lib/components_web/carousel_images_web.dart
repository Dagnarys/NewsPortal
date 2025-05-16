import 'package:flutter/material.dart';

class CarouselImagesWeb extends StatefulWidget {
  final List<String> imageUrls;

  const CarouselImagesWeb({super.key,required this.imageUrls, });

  @override
  State<CarouselImagesWeb> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImagesWeb> {
  final PageController _pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.8,
  );
  int _currentPage = 0;
  void _openFullScreen(int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => FullScreenGallery(
          imageUrls: widget.imageUrls,
          initialIndex: index,
        ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      // Если только одно изображение — показываем его без PageView
  if (widget.imageUrls.isEmpty) {
    print('пусто');
    return SizedBox.shrink(); // или Container с сообщением "Нет изображений"
  }
  
  if (widget.imageUrls.length == 1) {
    return GestureDetector(
      onTap: () => _openFullScreen(0),
      child: Center(
        child: Image.network(
          widget.imageUrls[0],
          fit: BoxFit.cover,
          width: 500,
          

          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(child: CircularProgressIndicator());
          },
          errorBuilder: (_, __, ___) => Icon(Icons.error_outline),
        ),
      ),
    );
  }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            color: Colors.white,
            width: 500,
            height: 300,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _openFullScreen(index),
                  child: Transform.scale(
                    scale: index == _currentPage ? 1.0 : 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          widget.imageUrls[index],
                          fit: BoxFit.cover,
                          width: 500,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error);
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
class FullScreenGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenGallery({super.key, 
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  _FullScreenGalleryState createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _pageController;
  int _currentIndex = 0;
  double _verticalDragOffset = 0.0;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }
  void _handleVerticalDrag(DragUpdateDetails details) {
    setState(() {
      _verticalDragOffset += details.primaryDelta!;
      // Ограничиваем смещение для плавности
      _verticalDragOffset = _verticalDragOffset.clamp(-150.0, 150.0);
      // Изменяем прозрачность в зависимости от смещения
      _opacity = (1 - (_verticalDragOffset.abs() / 300)).clamp(0.5, 1.0);
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    // Если смещение достаточно большое - закрываем галерею
    if (_verticalDragOffset.abs() > 100) {
      Navigator.pop(context);
    } else {
      // Иначе возвращаем на место
      setState(() {
        _verticalDragOffset = 0.0;
        _opacity = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: _handleVerticalDrag,
        onVerticalDragEnd: _handleVerticalDragEnd,
        child: Transform.translate(
          offset: Offset(0, _verticalDragOffset),
          child: Opacity(
            opacity: _opacity,
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: widget.imageUrls.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return InteractiveViewer(
                        panEnabled: _verticalDragOffset == 0, // Отключаем pan при драге
                        minScale: 1.0,
                        maxScale: 3.0,
                        child: Center(
                          child: Hero(
                            tag: 'image_$index',
                            child: Image.network(
                              width: 1000,
                              widget.imageUrls[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    '${_currentIndex + 1}/${widget.imageUrls.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}