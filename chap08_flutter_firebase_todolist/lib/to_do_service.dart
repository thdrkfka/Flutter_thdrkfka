import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ToDoService extends ChangeNotifier {
  final todoCollection = FirebaseFirestore.instance.collection('toDo');

  // 읽기
  /**
   * QuerySnapShot : 파이어베이스에서 쿼리를 실행한 결과로 반환되는 객체
   * 쿼리 결과로 반환된 여러 doc의 스냅샷을 가지고 있다.
   */
  Future<QuerySnapshot> read(String uid) async {
    // 내 toDoList 가져오기
    throw UnimplementedError(); // 임시로 return 값 미구현 에러
  }

  // 쓰기
  void create(String job, String uid) async {
    // todo 만들기
    await todoCollection.add({
      'uid': uid,
      'job': job,
      'isDone': false,
    });
    notifyListeners();
  }

  // 수정
  void update(String docId, bool isDone) async {
    // toDo isDone update
  }

  // 삭제
  void delete(String docId) async {
    // toDo 삭제
  }
}
