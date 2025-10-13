import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class CarouselHeader extends StatelessWidget {
  const CarouselHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      'https://via.placeholder.com/800x400/FF5733/FFFFFF?text=Banner+1',
      'https://via.placeholder.com/800x400/33FF57/FFFFFF?text=Banner+2',
      'https://via.placeholder.com/800x400/3357FF/FFFFFF?text=Banner+3',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: FlutterCarousel(
        options: CarouselOptions(
          height: 180.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          viewportFraction: 0.9,
          aspectRatio: 16 / 9,
          initialPage: 0,
        ),
        items: imageUrls.map((url) {
          return Builder(
            builder: (BuildContext context) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}