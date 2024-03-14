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
      title: 'App 타이틀',
      // App의 전반적인 테마를 설정한다.
      theme: ThemeData(
        textTheme: TextTheme(
          // 텍스트의 style을 미리 설정하고 호출해 사용 가능하다.
          bodyText1: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      home: Scaffold(
        appBar: AppBar(
          title: Text('AppBar'),
          backgroundColor: Colors.blue,
        ),

        // Body
        body: Text('Body 입니다.'),

        // BottomNavigationBar
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'school',
            ),
          ],
        ),

        //FloatingAcionButton
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.access_alarm),
            onPressed: () => {
                  print('hello'),
                }),
      ),
    );
  }
}
