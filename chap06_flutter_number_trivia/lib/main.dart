import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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

// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// 홈 페이지의 상태 클래스
class _HomePageState extends State<HomePage> {
  String quiz = '퀴즈';

  /**
   * initState()
   * StatefulWidget에서 위젯이 처음 생성될 때, 처음 실행되는 함수
   */
  @override
  void initState() {
    super.initState();
    // 퀴즈 정보 불러와서 화면 갱신하기
    getQuiz();
  }

  // Numbers API 호출하기
  Future<String> getNumbertrivia() async {
    String path = 'http://numbersapi.com/random/trivia';
    Response result = await Dio().get(path);

    String trivia = result.data;
    print(trivia);

    return trivia;
  }

  // 버튼을 눌렀을 때, 동작해서 새로운 퀴즈 나오는 거
  // 재사용하기 위해 분리
  void getQuiz() async {
    String trivia = await getNumbertrivia();
    setState(() {
      quiz = trivia;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.indigo,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            /**
             * 크로스 축 이란?
             * "사용하는 위젯의 주축의 반대 되는 축"을 '크로스 축'이라고 한다.
             * Column의 주축 => 세로 방향, 크로스 축 => 가로 방향
             */
            // CrossAxisAlignment.stretch : 크로스 축 방향으로 가능한 많은 공간을 차지하게 함.
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /**
               * Expanded
               * 레이아웃 위젯
               * 자식 위젯이 사용 가능한 추가 공간을 모두 차지하도록 확장시키는 역할
               * 주로 Row, Column과 같은 레이아웃 위젯을 사용할 때,
               * 내부의 자식 위젯들 사이의 공간을 동적으로 분배할 목적으로 사용됨.
               */
              Expanded(
                child: Center(
                  child: Text(
                    quiz,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // 퀴즈 생성 버튼
              SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: () {
                    // 버튼을 눌렀을 때 동작 // 얘 분리해서 재사용 할 예정
                    getQuiz();
                  },
                  child: Text(
                    'New Quiz',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.indigo,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
