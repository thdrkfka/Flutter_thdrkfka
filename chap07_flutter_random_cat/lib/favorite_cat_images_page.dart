import 'package:chap07_flutter_random_cat/cat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteCatImagesPage extends StatefulWidget {
  const FavoriteCatImagesPage({super.key});

  @override
  State<FavoriteCatImagesPage> createState() => _FavoriteCatImagesPageState();
}

class _FavoriteCatImagesPageState extends State<FavoriteCatImagesPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            title: Text(
              '좋아요 누른 고양이 사진들',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          // GridView count 생성자로, 그리드 내 아이템 수를 기반으로 레이아웃을 구성할 수 있다.
          body: GridView.count(
            // 크로스축으로 아이템이 2개씩 배치되도록 설정
            crossAxisCount: 2,
            // 그리드의 주축(세로) 사이의 아이템 공간 설정
            mainAxisSpacing: 8,
            // 그리드의 크로스축(가로) 사이의 아이템 공간 설정
            crossAxisSpacing: 8,
            // 그리드 전체에 대한 패딩 설정
            padding: EdgeInsets.all(8),
            children:
                List.generate(catService.favoriteCatImages.length, (index) {
              String catImage = catService.favoriteCatImages[index];
              return GestureDetector(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        catImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Icon(
                        Icons.favorite,
                        color: catService.favoriteCatImages.contains(catImage)
                            ? Colors.red
                            : Colors.transparent, // 투명색으로 해준다.
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
