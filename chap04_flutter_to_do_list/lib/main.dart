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

// ToDo 클래스
class ToDo {
  String job; // 할 일
  bool isDone; // 완료 여부

  ToDo(this.job, this.isDone); // 생성자
}

// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// 상태 클래스
class _HomePageState extends State<HomePage> {
  List<ToDo> toDoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'ToDoList',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: toDoList.isEmpty
          ? Center(
              child: Text('ToDoList 작성해주세요.'),
            )
          : ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                ToDo toDo = toDoList[index];
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
                  trailing: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return showDeleteDialog(context, index);
                            });
                      },
                      icon: Icon(CupertinoIcons.delete)),
                  onTap: () {
                    // 클릭 시
                    setState(() {
                      toDo.isDone = !toDo.isDone;
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? job = await Navigator.push(
              context, MaterialPageRoute(builder: (_) => CreatePage()));
          if (job != null) {
            setState(() {
              ToDo newToDo = ToDo(job, false);
              toDoList.add(newToDo);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // 삭제 기능 alert dialog 창 분리
  AlertDialog showDeleteDialog(BuildContext context, int index) {
    return AlertDialog(
      title: Center(child: Text('삭제 하시겠습니까?')),
      actions: [
        // 취소 버튼
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              '취소',
              style: TextStyle(color: Colors.blue),
            )),
        // 삭제 버튼
        TextButton(
            onPressed: () {
              setState(() {
                toDoList.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: Text(
              '삭제',
              style: TextStyle(color: Colors.red),
            )),
      ],
    );
  }
}

// ToDo 생성 페이지
class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

// ToDoList 등록
class _CreatePageState extends State<CreatePage> {
  // TextField의 값을 가져올 때 사용
  TextEditingController textController = TextEditingController();

  // 경고 메세지 변수
  String? error; // 메세지가 안 나올 수도 있으니까 nullable

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          'ToDoList 작성 페이지',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        // 뒤로가기 버튼
        leading: IconButton(
            onPressed: () {
              // 이전 페이지로 이동
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.chevron_back,
              color: Colors.white,
            )),
      ),
      body: Column(
        children: [
          // 텍스트 입력창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
              // 화면이 나왔을 경우, 입력창에 커서가 바로 오게 하는 기능
              autofocus: true,
              decoration:
                  InputDecoration(hintText: '할 일을 입력하세요.', errorText: error),
            ),
          ),

          SizedBox(
            height: 15,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            // sizedBox
            // 1. child 위젯의 size를 강제하기 위해 사용
            // 2. Row, Column 등에서 위젯 사이에 빈 공간을 넣기 위해 사용
            child: SizedBox(
              width: double.infinity, // 가로로 끝까지 갈 수 있도록 함.
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  // 추가하기 버튼을 클릭하면 작동
                  String toDo = textController.text;
                  // toDo의 상태에 따라 변함. => setState() 사용
                  if (toDo.isEmpty) {
                    setState(() {
                      error = '내용을 입력해주세요.';
                    });
                  } else {
                    setState(() {
                      error = null;
                    });
                  }
                  Navigator.pop(context, toDo);
                },
                child: Text(
                  '추가하기',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
