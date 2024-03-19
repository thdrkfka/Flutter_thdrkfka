import 'package:chap05_flutter_provider_to_do_list/to_do_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ToDoService()),
      ],
      child: const MyApp(),
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

// ToDo 클래스
class ToDo {
  String job; // 할 일
  bool isDone; // 완료 여부

  ToDo(this.job, this.isDone); // 생성자
}

// 홈 페이지
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Consumer _ 위젯트리 최상단에 등록되 Bucket 리스트에 접근
    // Consumer<[찾아올 클래스이름]>(
    //   builder: (context, [받아올 클래스 이름], child) {
    //     return [위젯];
    //   }
    // );

    return Consumer<ToDoService>(builder: (context, toDoService, child) {
      // toDoService로 부터 toDoList 가져오기
      List<ToDo> toDoList = toDoService.toDoList;

      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(fontSize: 25, color: Colors.white),
          title: Text('ToDo 리스트'),
        ),
        body: toDoList.isEmpty
            ? Center(
                child: Text('To Do List를 작성해주세요.'),
              )
            : ListView.builder(
                itemCount: toDoList.length,
                itemBuilder: (context, index) {
                  ToDo toDo = toDoList[index];

                  // ListTile : 리스트 아이템을 표현하기 위한 위젯
                  return ListTile(
                    title: Text(
                      toDo.job,
                      style: TextStyle(
                        fontSize: 20,
                        color: toDo.isDone ? Colors.grey : Colors.black,
                        decoration: toDo.isDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    // ListTile - trailing : 리스트 타일의 오른쪽 끝에 위젯을 배치하는 옵션
                    trailing: IconButton(
                      icon: Icon(CupertinoIcons.delete),
                      onPressed: () {
                        // delete 아이콘 클릭 시
                        toDoService.deleteToDo(index);
                      },
                    ),

                    onTap: () {
                      // 리스트 클릭 시
                      toDo.isDone = !toDo.isDone;
                      // isDone의 내용이 수정 됨.
                      toDoService.updateToDo(toDo, index);
                    },
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            // + 버튼을 클릭 시, ToDo 생성 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CreatePage()),
            );
          },
        ),
      );
    });
  }
}

// ToDo 생성 페이지
class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  // TextField 의 값을 가져올 때 사용
  TextEditingController textController = TextEditingController();

  // 경고 메세지 // nullable
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'ToDo 리스트 작성',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        // 뒤로 가기 버튼
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_back),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // 텍스트 입력창 = TextField
            TextField(
              controller: textController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'To Do List를 작성해주세요.',
                errorText: error,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                child: Text(
                  '추가하기',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                onPressed: () {
                  // 추가하기 버튼 클릭 시
                  String job = textController.text;
                  if (job.isEmpty) {
                    // StatefulWidget 에서 제공하는 함수..?
                    // 변경사항을 갱신해서 다시 build 해서 보여줌.
                    setState(() {
                      // 내용이 없는 경우 에러 메세지
                      error = '내용을 입력해주세요.';
                    });
                  } else {
                    setState(() {
                      // 내용이 있는 경우 에러 메세지 숨김
                      error = null;
                    });
                    // read : Provider 패키지의 메서드, 지정된 타입의 인스턴스를 읽어오기 위해 사용
                    // ToDoService 인스턴스 생성
                    ToDoService todoService = context.read<ToDoService>();
                    // ToDoSevice에 있는 createToDo 메서드 사용
                    todoService.createToDo(job);
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
