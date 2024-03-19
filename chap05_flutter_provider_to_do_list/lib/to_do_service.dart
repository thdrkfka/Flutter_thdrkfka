import 'package:flutter/cupertino.dart';

import 'main.dart';

// CRUD 작업

// ToDoList 담당(read)
class ToDoService extends ChangeNotifier {
  List<ToDo> toDoList = [
    //더미데이터
    ToDo('공부하기', false),
  ];

  // todo 추가 (create)
  void createToDo(String job) {
    toDoList.add(ToDo(job, false));
    // 갱신 : Consumer로 등록된 곳의 builder만 새로 갱신해서 화면을 그려줌.
    notifyListeners();
  }

  // todo 수정 (update)
  void updateToDo(ToDo toDo, int index) {
    toDoList[index] = toDo;
    notifyListeners();
  }

  //todo 삭제 (delete)
  void deleteToDo(int index) {
    toDoList.removeAt(index);
    notifyListeners();
  }
}
