// 홈 페이지
import 'package:chap07_flutter_random_cat/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cat_service.dart';
import 'favorite_cat_images_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CatService>(
      builder: (context, catService, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            actions: [
              IconButton(
                onPressed: () {
                  // icon 클릭시 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => FavoriteCatImagesPage()),
                  );
                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              ),
            ],
            title: Text(
              '랜덤 고양이',
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
            // 그리드에 표시될 위젯의 리스트. 10 개의 위젯을 생성
            children: List.generate(catService.catImages.length, (index) {
              String catImage = catService.catImages[index];
              /**
               * GestureDetector
               * 제스처를 감지하기 위해 onPressed, onTab을 직접 위젯에 넣는 대신에 GestureDetector 위젯을 이용해서 훨씬 더 많은 범위의 위젯을 감지
               */
              return GestureDetector(
                child: Stack(
                  children: [
                    /**
                     * Positioned
                     * Stack(겹치면서 쌓는 것) 내에서 자식 위젯의 위치를 정밀하게 제어할 때 사용.
                     * top, right, bottom, left 4가지 속성으로 위치를 조정.
                     * Positioned.fill 4가지 속성이 모두 0 으로 설정
                     * Stack 모든 면을 채우도록 설정.
                     */
                    Positioned.fill(
                      child: Image.network(
                        catImage,
                        fit: BoxFit.cover,
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
                onTap: () {
                  // 사진 클릭 시 작동
                  catService.toggleFavoriteImage(catImage);
                },
              );
            }),
          ),
        );
      },
    );
  }
}
