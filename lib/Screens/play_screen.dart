import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_quizz/object/cau_hoi_object.dart';
import 'package:game_quizz/object/chu_de_object.dart';
import 'package:game_quizz/object/profile_object.dart';

import 'package:game_quizz/provider/cau_hoi_provider.dart';
import 'package:game_quizz/provider/chu_de_provider.dart';
import 'package:game_quizz/provider/profile_provider.dart';
import 'package:game_quizz/screens/home.dart';
import 'package:game_quizz/const/colors.dart';
import 'package:game_quizz/const/text_style.dart';
import 'package:game_quizz/play/components/custome_alert.dart';
import 'package:game_quizz/play/components/helping_icons_row.dart';
import 'package:game_quizz/screens/nextpage.dart';
import 'package:intl/intl.dart';

class PlayScreen extends StatefulWidget {
  String email;
  int id;
  PlayScreen({super.key, required this.email, required this.id});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  @override
  CollectionReference lichsu = FirebaseFirestore.instance.collection('lichsu');
  DateTime ngay = DateTime.now();
  late String a, b, c, d;
  bool isLoaded = false;
  Timer? timer;
  int seconds = 30;
  int maxsecond = 30;
  List<ProfileObject> profile = [];
  List<ChuDeObject> chuDe = [];
  late String ngayHienTai;
  int soCauDung = 0;
  int soCauSai = 0;
  int heart = 3;
  bool is5050Used = false;
  bool isSwitchUsed = false;
  int currentQuestionIndex = 0;

  List optionsList = [];
  int points = 0;
  List<CauHoiObject> cauHoi = [];

  List<Color> optionsColor1 = [
    Colors.white,
  ];
  List<Color> optionsColor2 = [
    Colors.white,
  ];
  List<Color> optionsColor3 = [
    Colors.white,
  ];
  List<Color> optionsColor4 = [
    Colors.white,
  ];
  resetColors() {
    optionsColor1 = [
      Colors.white,
    ];
    optionsColor2 = [
      Colors.white,
    ];
    optionsColor3 = [
      Colors.white,
    ];
    optionsColor4 = [
      Colors.white,
    ];
  }

  Future<void> loadThongTin() async {
    final data = await ProfileProvider.getUsers(widget.email);
    setState(() {});
    profile = data;
  }

  Future<void> loadChuDe() async {
    final data = await ChuDeProvider.getDataById();
    setState(() {});
    chuDe = data;
  }

  void resetGame() {
    isLoaded = false;
    currentQuestionIndex = 0;
    resetColors();
    timer?.cancel();
    seconds = 30;
    points = 0;
    is5050Used = false;
    isSwitchUsed = false;
  }

  void getNgay() {
    ngayHienTai = DateFormat('dd/MM/yyyy').format(ngay);
  }

  gotoNextQuestion() {
    isLoaded = false;
    currentQuestionIndex++;
    resetColors();
    timer!.cancel();
    seconds = 30;
    maxsecond = 30;
    startTimer();
  }

  @override
  void initState() {
    super.initState();
    getNgay();
    loadThongTin();
    loadChuDe();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> addLichSu() async => lichsu.add({
        'tenNguoiChoi': profile[0].name,
        'ngayChoi': ngayHienTai,
        'soCauDung': soCauDung,
        'soCauSai': soCauSai,
        'tongDiem': points,
      });
  hetLuotChoi() {
    timer?.cancel();
    addLichSu();
    customAlert(
            context: context,
            onPressed: () {
              //gotoNextQuestion();
              //heart += 1;
              //Navigator.pop(context);
              nextpage(context, HomeScreen(email: widget.email));
            },
            title: 'Ồ đã hết lượt chơi rồi!',
            desc: 'Bạn có $points điểm',
            text: 'Okay')
        .show();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          timer.cancel();
          heart--;
          gotoNextQuestion();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<List<CauHoiObject>>(
      future: CauHoiProvider.getDataById(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<CauHoiObject> cauHoi = snapshot.data!;
          if (isLoaded == false) {
            if (currentQuestionIndex < 10) {
              a = cauHoi[currentQuestionIndex].dap_an_1;
              b = cauHoi[currentQuestionIndex].dap_an_2;
              c = cauHoi[currentQuestionIndex].dap_an_3;
              d = cauHoi[currentQuestionIndex].dap_an_4;

              isLoaded = true;
            } else {
              print('');
            }
          }
          return Scaffold(
            body: SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [blue, darkBlue],
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                                onPressed: () {
                                  timer!.cancel();
                                  addLichSu();
                                  customAlert(
                                    context: context,
                                    title: 'Thoát trò chơi',
                                    desc:
                                        'Kết thúc trò chơi và bạn có $points điểm',
                                    text: 'Thoát',
                                    onPressed: () {
                                      setState(() {
                                        timer!.cancel();
                                        resetGame();
                                      });
                                      nextpage(
                                          context,
                                          HomeScreen(
                                            email: widget.email,
                                          ));
                                    },
                                  ).show();
                                },
                                icon: const Icon(
                                  CupertinoIcons.xmark,
                                  color: Colors.white,
                                  size: 18,
                                )),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: null,
                                icon: const Icon(CupertinoIcons.heart_fill,
                                    color: Colors.red, size: 18),
                                label: normalText(
                                  color: Colors.white,
                                  text: '$heart',
                                ),
                              ),
                              TextButton.icon(
                                  onPressed: null,
                                  icon: const Icon(
                                      CupertinoIcons.money_dollar_circle,
                                      color: Color.fromARGB(255, 228, 207, 16),
                                      size: 18),
                                  label: normalText(
                                      color: Colors.white, text: '$points')),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          normalText(
                              color: Colors.white, size: 20, text: '$seconds'),
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              value: seconds / maxsecond,
                              valueColor:
                                  const AlwaysStoppedAnimation(Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: normalText(
                              color: lightgrey,
                              size: 20,
                              text: 'Câu số ${currentQuestionIndex + 1}:')),
                      const SizedBox(height: 20),
                      normalText(
                          color: Colors.white,
                          size: 25,
                          text: currentQuestionIndex < 10
                              ? cauHoi[currentQuestionIndex].cauHoi
                              : ''),
                      const SizedBox(height: 20),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: 1,
                          itemBuilder: (context, index) => Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (cauHoi[currentQuestionIndex]
                                                .dap_an_dung
                                                .toString() ==
                                            a) {
                                          optionsColor1[index] = Colors.green;
                                          points += 100;
                                          soCauDung++;
                                        } else {
                                          optionsColor1[index] = Colors.red;
                                          heart -= 1;
                                          if (heart == 0) {
                                            timer!.cancel();
                                            hetLuotChoi();
                                          }
                                          soCauSai++;
                                        }
                                      });
                                      if (currentQuestionIndex <
                                          cauHoi.length - 1) {
                                        Future.delayed(
                                            const Duration(seconds: 1), () {
                                          setState(gotoNextQuestion);
                                        });
                                      } else {
                                        timer!.cancel();
                                        addLichSu();
                                        if (currentQuestionIndex > 10 &&
                                            cauHoi[currentQuestionIndex]
                                                    .cauHoi
                                                    .length >
                                                10) {
                                          customAlert(
                                                  context: context,
                                                  onPressed: () {
                                                    setState(() {
                                                      timer!.cancel();
                                                      resetGame();
                                                    });
                                                    nextpage(
                                                        context,
                                                        HomeScreen(
                                                            email:
                                                                widget.email));
                                                  },
                                                  title:
                                                      'Số câu đúng: $soCauDung.\n Số câu sai: $soCauSai',
                                                  desc:
                                                      'Chúc mừng bạn đã có $points điểm. ',
                                                  text: 'Màn hình chính')
                                              .show();
                                        }
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      width: size.width - 100,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: optionsColor1[index],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: headingText(
                                        color: blue,
                                        size: 18,
                                        text: a,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (cauHoi[currentQuestionIndex]
                                                .dap_an_dung
                                                .toString() ==
                                            b) {
                                          optionsColor2[index] = Colors.green;
                                          points += 100;
                                          soCauDung++;
                                        } else {
                                          optionsColor2[index] = Colors.red;
                                          heart -= 1;
                                          if (heart == 0) {
                                            timer!.cancel();
                                            hetLuotChoi();
                                          }

                                          soCauSai++;
                                        }
                                        if (currentQuestionIndex <
                                            cauHoi.length - 1) {
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            setState(gotoNextQuestion);
                                          });
                                        } else {
                                          timer!.cancel();
                                          addLichSu();
                                          customAlert(
                                                  context: context,
                                                  onPressed: () {
                                                    setState(() {
                                                      timer!.cancel();
                                                      resetGame();
                                                    });
                                                    nextpage(
                                                        context,
                                                        HomeScreen(
                                                            email:
                                                                widget.email));
                                                  },
                                                  title:
                                                      'Số câu đúng: $soCauDung.\n Số câu sai: $soCauSai',
                                                  desc:
                                                      'Chúc mừng bạn đã có $points điểm. Hãy thử lại nào.',
                                                  text: 'Đồng ý')
                                              .show();
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      width: size.width - 100,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: optionsColor2[index],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: headingText(
                                        color: blue,
                                        size: 18,
                                        text: b,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (cauHoi[currentQuestionIndex]
                                                .dap_an_dung
                                                .toString() ==
                                            c) {
                                          optionsColor3[index] = Colors.green;
                                          points += 100;
                                          soCauDung++;
                                        } else {
                                          optionsColor3[index] = Colors.red;
                                          heart -= 1;
                                          if (heart == 0) {
                                            timer!.cancel();
                                            hetLuotChoi();
                                          }

                                          soCauSai++;
                                        }
                                        if (currentQuestionIndex <
                                            cauHoi.length - 1) {
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            setState(gotoNextQuestion);
                                          });
                                        } else {
                                          timer!.cancel();
                                          addLichSu();
                                          customAlert(
                                                  context: context,
                                                  onPressed: () {
                                                    setState(() {
                                                      timer!.cancel();
                                                      resetGame();
                                                    });
                                                    nextpage(
                                                        context,
                                                        HomeScreen(
                                                            email:
                                                                widget.email));
                                                  },
                                                  title:
                                                      'Số câu đúng: $soCauDung.\n Số câu sai: $soCauSai',
                                                  desc:
                                                      'Chúc mừng bạn đã có $points điểm. Hãy thử lại nào.',
                                                  text: 'Đồng ý')
                                              .show();
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      width: size.width - 100,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: optionsColor3[index],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: headingText(
                                        color: blue,
                                        size: 18,
                                        text: c,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (cauHoi[currentQuestionIndex]
                                                .dap_an_dung
                                                .toString() ==
                                            d) {
                                          optionsColor4[index] = Colors.green;
                                          points += 100;
                                          soCauDung++;
                                        } else {
                                          optionsColor4[index] = Colors.red;
                                          heart -= 1;
                                          if (heart == 0) {
                                            timer!.cancel();
                                            hetLuotChoi();
                                          }

                                          soCauSai++;
                                        }
                                        if (currentQuestionIndex <
                                            cauHoi.length - 1) {
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            setState(gotoNextQuestion);
                                          });
                                        } else {
                                          timer!.cancel();
                                          addLichSu();
                                          customAlert(
                                                  context: context,
                                                  onPressed: () {
                                                    setState(() {
                                                      timer!.cancel();
                                                      resetGame();
                                                    });
                                                    nextpage(
                                                        context,
                                                        HomeScreen(
                                                            email:
                                                                widget.email));
                                                  },
                                                  title:
                                                      'Số câu đúng: $soCauDung.\n Số câu sai: $soCauSai',
                                                  desc:
                                                      'Chúc mừng bạn đã có $points điểm. Hãy thử lại nào.',
                                                  text: 'Đồng ý')
                                              .show();
                                        }
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      alignment: Alignment.center,
                                      width: size.width - 100,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: optionsColor4[index],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: headingText(
                                        color: blue,
                                        size: 18,
                                        text: d,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              helpingIconsRow(
                                is5050UsedValue: is5050Used,
                                isSwitchUsedValue: isSwitchUsed,
                                functionOF5050: () {
                                  setState(() {
                                    final String dapAnDung =
                                        cauHoi[currentQuestionIndex]
                                            .dap_an_dung
                                            .toString();
                                    if (is5050Used == false) {
                                      int myCount = 0;
                                      for (int i = 0; i < 1; i++) {
                                        if (cauHoi[currentQuestionIndex]
                                                    .dap_an_1[i] !=
                                                cauHoi[currentQuestionIndex]
                                                    .dap_an_dung &&
                                            myCount <= 1 &&
                                            a == dapAnDung) {
                                          b = '';
                                          c = '';

                                          myCount++;
                                        } else if (cauHoi[currentQuestionIndex]
                                                    .dap_an_2[i] !=
                                                cauHoi[currentQuestionIndex]
                                                    .dap_an_dung &&
                                            myCount <= 1 &&
                                            b == dapAnDung) {
                                          c = ' ';
                                          d = ' ';
                                          myCount++;
                                        } else if (cauHoi[currentQuestionIndex]
                                                    .dap_an_3[i] !=
                                                cauHoi[currentQuestionIndex]
                                                    .dap_an_dung &&
                                            myCount <= 1 &&
                                            c == dapAnDung) {
                                          a = ' ';
                                          d = ' ';
                                          myCount++;
                                        } else if (cauHoi[currentQuestionIndex]
                                                    .dap_an_4[i] !=
                                                cauHoi[currentQuestionIndex]
                                                    .dap_an_dung &&
                                            myCount <= 1 &&
                                            d == dapAnDung) {
                                          a = ' ';
                                          c = ' ';
                                          myCount++;
                                        }
                                      }
                                      is5050Used = true;
                                    }
                                  });
                                },
                                switchFunction: () {
                                  setState(() {
                                    if (isSwitchUsed == false) {
                                      gotoNextQuestion();
                                      isSwitchUsed = true;
                                      if (currentQuestionIndex >= 10) {
                                        addLichSu();
                                        timer?.cancel();
                                        customAlert(
                                                context: context,
                                                onPressed: () {
                                                  setState(() {
                                                    timer!.cancel();
                                                    resetGame();
                                                  });
                                                  nextpage(
                                                      context,
                                                      HomeScreen(
                                                          email: widget.email));
                                                },
                                                title:
                                                    'Số câu đúng: $soCauDung.\n Số câu sai: $soCauSai',
                                                desc:
                                                    'Chúc mừng bạn đã có $points điểm. Hãy thử lại nào.',
                                                text: 'Xem chi tiết')
                                            .show();
                                      }
                                    }
                                  });
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Text('');
      },
    );
  }
}
