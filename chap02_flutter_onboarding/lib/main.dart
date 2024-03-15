import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 전역변수 사용 => 모든 method 바깥에 선언
/**
 *  SharedPreference
    : 데이터를 메모리가 아닌 다른 곳에 저장해 앱을 재시작해도 이전 데이터를 유지하는 방법
    :로그인 정보 저장, 알림 수신 동의, 초기 설정값 같은 DB를 사용하기는 부담스러운 간단한 정보를 저장
 */
// SharedPreferences 인스턴스를 어디서든 접근 가능하도록 전역 변수로 선언
// late : 나중에 꼭 값을 할당해준다는 의미.
late SharedPreferences prefs;

void main() async {
  // main() 함수에서 async를 쓰려면 필요
  WidgetsFlutterBinding.ensureInitialized();

  // Shared_preferences 인스턴스 생성
  // await 사용 이유? 파일을 읽어오는데 시간이 걸리니까 기다렸다가 다 읽으면 불러오겠다.
  prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SharedPreferences 에서 온보딩 완료 여부 조회
    // isOnboarded에 해당하는 값에서 null을 반환하는 경우 false를 기본값으로 지정
    bool isOnboarded =
        prefs.getBool('isOnboarded') ?? false; // nullable => null = false

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // backgroundColor: Color.fromARGB(255, 36, 34, 34),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // isOnboarded 가 true면 홈페이지, false면 테스트스크린
      home: isOnboarded ? HomePage() : TestScreen(),
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
        // 마지막 페이지가 나오거나 skip을 해서 HomePage로 가기 전에 isOnboarded를 true로 바꿔준다.
        prefs.setBool('isOnboarded', true);
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
        actions: [
          IconButton(
            onPressed: () {
              prefs.clear();
            },
            icon: Icon(Icons.delete),
          ),
        ],
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
