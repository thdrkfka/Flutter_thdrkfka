import 'package:chap08_flutter_firebase_todolist/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'to_do_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // firebase app 시작
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ToDoService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: user == null ? LoginPage() : HomePage(),
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
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        // 로그인한 유저 객체 가져오기
        User? user = authService.currentUser();
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
                    user == null ? '로그인 해주세요.' : '${user.email} 님, 안녕하세요.',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(hintText: '이메일'),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true, // 비밀번호 숨김 표시
                  decoration: InputDecoration(hintText: '비밀번호'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 로그인
                    authService.signIn(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () {
                        // 로그인 성공 스낵바
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('로그인 성공'),
                          ),
                        );

                        // 로그인 성공 시 HomePage로 이동
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomePage(),
                            ));
                      },
                      onError: (err) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(err),
                          ),
                        ); // snackbar - 창이 올라왔다 사라짐.
                      },
                    );
                  },
                  child: Text(
                    '로그인',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // 회원가입 페이지로 이동
                    authService.signUp(
                      email: emailController.text,
                      password: passwordController.text,
                      onSuccess: () {
                        // 회원가입 성공
                        print('회원가입 성공');
                      },
                      onError: (err) {
                        // 회원가입 에러 발생
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err))); // snackbar - 창이 올라왔다 사라짐.
                      },
                    );
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
      },
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
    return Consumer<ToDoService>(
      builder: (context, toDoService, child) {
        // 로그인한 회원 정보를 가져오기 위해 AuthService를 context를 통해 위젯트리 최상단에서 가져옴.
        final AuthService authService = context.read<AuthService>();

        // 로그인 시에만 HomePage에 접근 가능하기 때문에 User는 null이 될 수 없다.
        // 따라서, !로 nullable을 지워준다. // nullable 강제로 없애기 => 뒤에 ! 붙이기
        User user = authService.currentUser()!;

        return Scaffold(
          appBar: AppBar(
            title: Text('TodoList'),
            actions: [
              TextButton(
                onPressed: () {
                  // 로그아웃 버튼을 눌렀을 때 로그인 페이지로 이동
                  // 일회성으로 참조해서 사용 가능
                  context.read<AuthService>().signOut();
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
                        if (jobController.text.isNotEmpty) {
                          toDoService.create(jobController.text, user.uid);
                        }
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
                /**
                 * FutureBuilder
                 * ToDoService read 기능은 통신을 통해 가져온다.
                 * 그래서 반환하는 값이 시간이 걸리는 Future여서 바로 화면에 보여 줄 수 없다.
                 * FutureBuild는 데이터를 요청할 때 builder가 등장하고, 데이터를 받아왔을 때, 다시 builder가 동작하여
                 * 데이터를 받아 온 뒤에 화면이 다시 그려지면서 데이털르 출력해줄 수 있다.
                 */
                child: FutureBuilder<QuerySnapshot>(
                    future: toDoService.read(user.uid),
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemCount: 1,
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
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
