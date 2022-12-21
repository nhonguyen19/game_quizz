import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:game_quizz/object/lich_su_object.dart';
import 'package:game_quizz/provider/lich_su_provider.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  List<LichSuObject> lsBangXepHang = [];
  Future<void> _LoadBangXepHang() async {
    final data = await LichSuProvider.getDataByAll();
    setState(() {});
    lsBangXepHang = data;
  }

  @override
  void initState() {
    super.initState();
    _LoadBangXepHang();
  }

  @override
  Widget build(BuildContext context) {
    const String src3 =
        'https://khoinguonsangtao.vn/wp-content/uploads/2022/07/avatar-cute-2-560x560.jpg';
    const String src2 =
        'https://khoinguonsangtao.vn/wp-content/uploads/2022/07/avatar-cute-2-560x560.jpg';
    const String src1 =
        'https://khoinguonsangtao.vn/wp-content/uploads/2022/07/avatar-cute-2-560x560.jpg';
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffF5F5F5),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 28, 100, 0),
          title: const Align(
            child: Text('Bảng xếp hạng'),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: ListView.builder(
              itemCount: lsBangXepHang.length,
              itemBuilder: (context, index) => Card(
                    elevation: 25,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color.fromARGB(255, 1, 206, 86), width: 2),
                          borderRadius: BorderRadius.circular(30)),
                      leading: Text('#${index + 1}',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      title: Text(lsBangXepHang[index].tenNguoiChoi,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Text(lsBangXepHang[index].ngayChoi.toString()),
                      trailing: Text('${lsBangXepHang[index].tongDiem}'),
                    ),
                  )),
        ),
      ),
    );
  }
}
