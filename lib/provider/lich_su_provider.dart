import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_quizz/object/lich_su_object.dart';

class LichSuProvider {
  static Future<List<LichSuObject>> getDataByAll() async {
    List<LichSuObject> lichSu = [];
    QuerySnapshot snapshot;
    snapshot = await FirebaseFirestore.instance
        .collection('lichsu')
        .orderBy('tongDiem', descending: true)
        .get();
    lichSu = snapshot.docs
        .map((json) =>
            LichSuObject.fromJson(json.data() as Map<String, dynamic>)) 
        .toList();
    return lichSu;
  }
}
