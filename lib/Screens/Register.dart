import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_quizz/object/profile_object.dart';
import 'package:game_quizz/play/components/customStartButton.dart';
import 'package:game_quizz/play/components/thongbao.dart';
import 'package:game_quizz/screens/login.dart';
import 'package:game_quizz/screens/nextpage.dart';
import 'package:game_quizz/screens/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _showPass = false;
  TextEditingController _txtName = TextEditingController();
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtPass = TextEditingController();
  TextEditingController _txtPhone = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    const edgeInsets = EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image(context),
              _header(context),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: TextField(
                  controller: _txtName,
                  decoration: InputDecoration(
                    hintText: "Tên đăng nhập",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: TextField(
                  controller: _txtPhone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Số điện thoại",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Icon(Icons.phone_android),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: TextField(
                  controller: _txtEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    filled: true,
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Stack(
                  alignment: AlignmentDirectional.centerEnd,
                  children: [
                    TextField(
                      obscureText: !_showPass,
                      controller: _txtPass,
                      decoration: InputDecoration(
                        hintText: "Mật khẩu",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        fillColor:
                            Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: true,
                        prefixIcon: Icon(Icons.password_outlined),
                      ),
                    ),
                    GestureDetector(
                      onTap: inTongleShowPass,
                      child: Icon(
                        !_showPass ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: ElevatedButton(
                    onPressed: () async {
                    
                      try {
                        List<ProfileObject> lsProfile=[];
                        CollectionReference users =
                            FirebaseFirestore.instance.collection('users');
                        await _firebaseAuth
                            .createUserWithEmailAndPassword(
                                email: _txtEmail.text, password: _txtPass.text)
                            .then((value) => users.add({
                                  'email': _txtEmail.text,
                                  'name': _txtName.text,
                                  'phone': _txtPhone.text,
                                }))
                            .then((value) {
                          nextpage(context, LoginApp());
                        });
                      } on FirebaseAuthException catch (error) {
                        thongbao(error.message.toString());
                      }
                    },
                    child: Text(
                      "Đăng kí",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(400, 55),
                      shape: StadiumBorder(),
                      backgroundColor: Color.fromARGB(255, 28, 100, 0)
                    )),
              ),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _txtEmail.dispose();
    _txtPass.dispose();
    _txtName.dispose();
    super.dispose();
  }

  @override
  void inTongleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  _image(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(
          "assets/image.png",
          width: 100,
          height: 100,
        ),
      ],
    );
  }

  _header(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        text_quizz(context),
      ],
    );
  }

  _signup(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Bạn đã có tài khoản?",
          style: TextStyle(color: Colors.black54, fontSize: 20),
        ),
        TextButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LoginApp()));
            },
            child: Text(
              "Đăng nhập ",
              style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 28, 100, 0)),
            ))
      ],
    );
  }
}
