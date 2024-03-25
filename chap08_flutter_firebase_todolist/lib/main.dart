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
      home: LoginPage(),
    );
  }
}

// 로그인 페이지
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                '로그인 해주세요.',
                style: TextStyle(fontSize: 25),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(hintText: '이메일'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: '비밀번호'),
            ),
            ElevatedButton(
              onPressed: () {
                // 로그인 성공 시 HomePage로 이동
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(),
                    ));
              },
              child: Text(
                '로그인',
                style: TextStyle(fontSize: 24),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 회원가입 페이지로 이동
              },
              child: Text(
                '회원 가입',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TodoList'),
        actions: [
          TextButton(
            onPressed: () {
              // 로그아웃 버튼을 눌렀을 때 로그인 페이지로 이동
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
            child: Text(
              '로그아웃',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: jobController,
                    decoration: InputDecoration(hintText: 'job을 입력해주세요.'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // add 버튼을 눌렀을 때 job을 추가
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                String job = '$index';
                bool isDone = false;

                return ListTile(
                  title: Text(
                    job,
                    style: TextStyle(
                        fontSize: 24,
                        color: isDone ? Colors.grey : Colors.black,
                        decoration: isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      // 삭제 버튼 눌렀을 때 동작
                    },
                    icon: Icon(CupertinoIcons.delete),
                  ),
                  onTap: () {
                    // 아이템을 클릭했을 때, isDone 상태 변경
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
