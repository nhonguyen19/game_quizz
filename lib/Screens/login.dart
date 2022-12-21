import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_quizz/play/components/thongbao.dart';
import 'package:game_quizz/screens/home.dart';
import 'package:game_quizz/screens/nextpage.dart';
import 'package:game_quizz/screens/widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:game_quizz/provider/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:game_quizz/screens/register.dart';

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtPass = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  late bool _showPass = false;


  @override
  Widget build(BuildContext context) {
    const edgeInsets = EdgeInsets.fromLTRB(10, 10, 10, 10);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/image.png',
                      width: 100,
                      height: 100,
                    ),
                    text_quizz(context),
                    const SizedBox(height: 20),
                    //Email
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: TextField(
                        controller: _txtEmail,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none),
                          fillColor:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                          filled: true,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                      ),
                    ),
                    //Mật khẩu
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Stack(
                        alignment: AlignmentDirectional.centerEnd,
                        children: [
                          TextField(
                            obscureText: !_showPass,
                            controller: _txtPass,
                            decoration: InputDecoration(
                              hintText: 'Mật khẩu',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none,
                              ),
                              fillColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              filled: true,
                              prefixIcon: const Icon(Icons.password_outlined),
                            ),
                          ),
                          GestureDetector(
                            onTap: inTongleShowPass,
                            child: Icon(
                              !_showPass
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            final user =
                                await _firebaseAuth.signInWithEmailAndPassword(
                                    email: _txtEmail.text,
                                    password: _txtPass.text);
                            _firebaseAuth.authStateChanges().listen((event) {
                              if (event != null) {
                                nextpage(
                                    context, HomeScreen(email: _txtEmail.text));
                              }
                            });
                            thongbao('Đăng nhập thành công');
                          } on FirebaseAuthException catch (e) {
                            thongbao(e.message.toString());
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 28, 100, 0),
                          fixedSize: const Size(400, 55),
                          shape: const StadiumBorder(),
                          padding: edgeInsets,
                        ),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Row(children: const <Widget>[
                        Expanded(
                            child: Divider(
                          color: Color.fromARGB(255, 28, 100, 0),
                          thickness: 1,
                        )),
                        Text(
                          'Hoặc',
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                            child: Divider(
                          color: Color.fromARGB(255, 28, 100, 0),
                          thickness: 1,
                        )),
                      ]),
                    ),


                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Center(
                        child: SignInButton(
                          Buttons.Google,
                          shape: const StadiumBorder(),
                          padding: edgeInsets,
                          elevation: 10.0,
                          text: 'Đăng nhập bằng google',
                          onPressed: () async {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            await provider.googleLogin(context).then(
                              (value) {
                                nextpage(
                                    context,
                                    HomeScreen(
                                        email:
                                            _firebaseAuth.currentUser!.email!));
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: _signup(context),
              ),
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
    super.dispose();
  }

  void inTongleShowPass() {
    setState(() {
      _showPass = !_showPass;
    });
  }

  Row _signup(context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Bạn chưa có tài khoản? ',
            style: TextStyle(color: Colors.black54, fontSize: 20),
          ),
          TextButton(
              onPressed: () {
                nextpage(context, const Register());
              },
              child: const Text(
                'Đăng kí',
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 28, 100, 0)),
              ))
        ],
      );
}
