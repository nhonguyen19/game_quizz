import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_quizz/object/lich_su_object.dart';
import 'package:game_quizz/play/components/custome_alert.dart';
import 'package:game_quizz/provider/lich_su_provider.dart';

class LichSuScreen extends StatefulWidget {
  const LichSuScreen({super.key});

  @override
  State<LichSuScreen> createState() => _LichSuScreenState();
}

class _LichSuScreenState extends State<LichSuScreen> {
  @override
  List<LichSuObject> lsLichSu = [];

  Future<void> _loadLS() async {
    final data = await LichSuProvider.getDataByAll();
    setState(() {});
    lsLichSu = data;
  }

  @override
  void initState() {
    _loadLS();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 28, 100, 0),
        title: const Align(
          child: Text('Lịch sử chơi'),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ListView.builder(
            itemCount: lsLichSu.length, //lsLichSu.length,
            itemBuilder: (context, index) => Card(
                  elevation: 25,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 1, 206, 86), width: 2),
                        borderRadius: BorderRadius.circular(30)),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: Image(
                          image: user.photoURL == null
                              ? const NetworkImage(
                                  'https://w7.pngwing.com/pngs/716/486/png-transparent-100-pics-quiz-guess-the-trivia-games-history-quiz-game-quiz-guess-word-quiz-up-2k17-trivia-history-quiz-game-logo-circle-thumbnail.png',
                                  scale: 2.0)
                              : NetworkImage(user.photoURL!, scale: 2.0)),
                    ),
                    title: Text(lsLichSu[index].tenNguoiChoi,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Text(lsLichSu[index].ngayChoi.toString()),
                    onTap: () {
                      setState(() {
                        customAlert(
                          title:
                              'Số câu đúng ${lsLichSu[index].soCauDung}\nSố câu sai ${lsLichSu[index].soCauSai}',
                          desc: 'Tổng điểm: ${lsLichSu[index].tongDiem}',
                          text: 'Okay',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          context: context,
                        ).show();
                      });
                    },
                  ),
                )),
      ),
    );
  }
}
