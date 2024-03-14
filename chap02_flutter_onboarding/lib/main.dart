import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // backgroundColor: Color.fromARGB(255, 36, 34, 34),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: '시작하는 나',
      subTitle: '아무것도 모르는 나 자신,,, 그저 시도를 했다,,,',
      imageUrl: 'assets/images/duck.jpg',
    ),
    Introduction(
      title: '현재의 나',
      subTitle: '아직도 아리송한 나 자신,,, 취뽀 가능한가,,?',
      imageUrl: 'assets/images/falco.jpg',
    ),
    Introduction(
      title: '수료 후의 나',
      subTitle: '약 1달 남았지만 왠지 성장해서 멋있을 것 같은 나 자신,,, 을 그려보는 현재의 나,,,',
      imageUrl: 'assets/images/eagle.jpg',
    ),
    Introduction(
      title: '10년 후의 나',
      subTitle: '삶의 풍파를 맞고 인고의 시간을 거쳐 마침내 체념하고 깨달은 나 자신,,, 그래도 나름의 삶이 만족스러운,,?',
      imageUrl: 'assets/images/Struthiocamelus.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      introductionList: list,
      onTapSkipButton: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ), //MaterialPageRoute
        );
      },
      // foregroundColor: Colors.red,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('😂우당탕탕 개발자 라이프😂'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          '앞으로 "송가람"의 일상을 기대해주세요!',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
