import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CatService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

/**
 * ChangeNotifier
 * 지정한 값이 변하게되면 해당 값을 보여주는 화면들을 갱신해주는 클래스
 * ChangeNotifier 를 상속하게 되면,notifylisteners() 를 호출하여, 위젯들을 갱신하는 기능
 */

class CatService extends ChangeNotifier {
  // 리스트 고양이 사진들
  List<String> catImages = [];

  // 좋아요 누른 사진들
  List<String> favoriteCatImages = [];

  // CatService 생성자
  CatService() {
    getRandomCatImages();
  }

  // 고양이 이미지 10개 가져오는 메서드
  void getRandomCatImages() async {
    String path =
        'https://api.thecatapi.com/v1/images/search?limit=10&mime_types=gif';
    var result = await Dio().get(path);
    print(result.data);
    for (int i = 0; i < result.data.length; i++) {
      var map = result.data[i];
      print(map);
      print(map['url']); // map(key, value)
      // java에서는 map.url 이런 식으로 뽑아오는데 dart 에서는 map['url'] 이런 식으로 뽑아옴.

      // catImages에 이미지 url 추가
      catImages.add(map['url']);
    }
    notifyListeners();
  }

  // 좋아요 기능 // String catImage => url 주소
  void toggleFavoriteImage(String catImage) {
    // 한번 눌렀을 때, 이미 있는 이미지면
    if (favoriteCatImages.contains(catImage)) {
      // 좋아요 취소..?
      favoriteCatImages.remove(catImage);
    } else {
      // 좋아요 추가..?
      favoriteCatImages.add(catImage);
    }

    notifyListeners();
  }
}

// 홈 페이지
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
                onPressed: () {},
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
              return GestureDetector(
                child: Stack(
                  children: [
                    /**
                     * positioned
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
