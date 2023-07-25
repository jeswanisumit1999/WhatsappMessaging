import 'package:bulkwamsg/LoginPage.dart';
import 'package:bulkwamsg/onBoard.dart';
import 'package:bulkwamsg/widgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  String email = "";
  String password = "";
  String confirmPassword = "";

  Dio dio = new Dio();
  final baseUrl = "http://ec2-16-170-205-112.eu-north-1.compute.amazonaws.com:5000/";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget _menuItem(title, isActive){
    return Padding(
      padding: const EdgeInsets.only(right: 75),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Column(
          children: [
            Text(
              '$title',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.deepPurple : Colors.grey,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            isActive
                ? Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(30),
              ),
            )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  signingWithGoogle() async {
    print("Inside fun");
    // FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential result = await _auth.signInWithCredential(credential);
    User? user = result.user;
    print(_auth.currentUser);
    return user;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFFf5f5f5),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 8),
          children: [
            const SizedBox(height: 25,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap:(){
                          setState(() {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => Login(),
                                transitionDuration: const Duration(seconds: 0),
                              ),
                            );
                            });
                        },
                        child: _menuItem('Sign In', false)),
                    GestureDetector(
                        onTap: (){
                          setState(() {
                            // signIn = false;
                            // print(signIn);
                          });
                        },
                        child: _menuItem('Register', true)
                    ),
                    // _registerButton()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: MediaQuery.of(context).size.width > 900,
                      child: Container(
                        width: 360,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Lets \nget onboarded',
                              style: TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "If you alredy have an account",
                              style: TextStyle(
                                  color: Colors.black54, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "You can",
                                  style: TextStyle(
                                      color: Colors.black54, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => Login(),
                                        transitionDuration: const Duration(seconds: 0),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Sign-in here!",
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              'images/illustration-2.png',
                              width: 300,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Image.asset(
                    //   'images/illustration-1.png',
                    //   width: 300,
                    // ),
                    MediaQuery.of(context).size.width >= 1300 //Responsive
                        ? Image.asset(
                      'images/illustration-1.png',
                      width: 300,
                    )
                        : SizedBox(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height / 6),
                      child: Container(
                          width: 320,
                          child: Column(
                            children: [
                              TextField(
                                onChanged: (val){
                                  email = val;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Enter email or Phone number',
                                  filled: true,
                                  fillColor: Colors.blueGrey[50],
                                  labelStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.only(left: 30),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              TextField(
                                onChanged: (val){
                                  password = val;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  // counterText: 'Forgot password?',
                                  suffixIcon: const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Colors.blueGrey[50],
                                  labelStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.only(left: 30),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),

                              SizedBox(height: 30),
                              TextField(
                                onChanged: (val){
                                  password = val;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  // counterText: 'Forgot password?',
                                  suffixIcon: const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: Colors.blueGrey[50],
                                  labelStyle: TextStyle(fontSize: 12),
                                  contentPadding: EdgeInsets.only(left: 30),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blueGrey),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 40),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.deepPurple,
                                      spreadRadius: 0,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () async {

                                    // Firebase Login flutter
                                    try {
                                      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                        email: email,
                                        password: password,
                                      );
                                      // final FirebaseAuth _auth = FirebaseAuth.instance;
                                      print(await _auth.currentUser?.getIdToken());
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'weak-password') {
                                        print('The password provided is too weak.');
                                        ToastFun("Password provided is too weak");
                                      } else if (e.code == 'email-already-in-use') {
                                        print('The account already exists for that email.');
                                        ToastFun("Account already exists");
                                      }
                                    } catch (e) {
                                      print(e);
                                    }

                                    if(_auth.currentUser != null){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Onboard()));
                                    }

                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: Center(child: Text("Register"))),
                                ),
                              ),

                              SizedBox(height: 40),
                              Row(children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[300],
                                    height: 50,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Or continue with"),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey[400],
                                    height: 50,
                                  ),
                                ),
                              ]),
                              SizedBox(height: 40),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        signingWithGoogle();
                                      },
                                      child: Container(
                                        width: 90,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: Center(
                                            child: Container(
                                              decoration:
                                              BoxDecoration(),
                                              child: Image.asset(
                                                'images/google.png',
                                                width: 35,
                                              ),
                                            )),
                                      )),
                                  //Sign in with Google
                                ],
                              ),
                            ],
                          )
                      ),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
