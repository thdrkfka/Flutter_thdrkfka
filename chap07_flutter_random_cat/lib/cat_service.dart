import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'main.dart';

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
    prefs.setStringList('favoriteCatImages', favoriteCatImages);
    notifyListeners();
  }
}
