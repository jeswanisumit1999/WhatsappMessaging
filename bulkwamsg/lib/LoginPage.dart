import 'package:bulkwamsg/DashboardNew.dart';
import 'package:bulkwamsg/Signup.dart';
import 'package:bulkwamsg/onBoard.dart';
import 'package:bulkwamsg/widgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'GlobalVariables.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Dio dio = new Dio();

  String email = "";
  String password = "";
  bool validate_Email = true;

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
            const SizedBox(
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
                : const SizedBox()
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


  redirect() async {
    final token = await _auth.currentUser?.getIdToken();
    dio.options.headers["Authorization"] = "Bearer $token";
    // dio.options.headers["Access-Control-Allow-Origin"] = "*";
    print("TOKEN : $token");
    var _response;
    try{
      _response = await dio.post(baseUrl + "/users/signin");
      print(_response.statusCode);
    }
    catch(e){
      ToastFun("Something went wrong !!!!!");
      print (e);
    };

    print(_response.data);
    if(_response.statusCode == 404){
      //onboard
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Onboard()));
    }
    if(_response.statusCode == 200){
      //Dashboard
      ToastFun("Login Success!!");
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  @override
  void initState() {
    print(_auth.currentUser?.email);
    if(_auth.currentUser?.uid != null){
      print("redirecting.....");
      redirect();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool signIn = true;
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
                            signIn = true;
                            print(signIn);
                          });
                        },
                        child: _menuItem('Sign In', true)),
                    GestureDetector(
                        onTap: (){
                          setState(() {
                           signIn = false;
                            print(signIn);
                          });
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => Signup(),
                              transitionDuration: const Duration(seconds: 0),
                            ),
                          );
                         // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Signup()));

                        },
                        child: _menuItem('Register', false)
                    ),
                    // _registerButton()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: MediaQuery.of(context).size.width > 900,
                      child: SizedBox(
                        width: 360,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sign In to \nMy Application',
                              style: TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            const Text(
                              "If you don't have an account",
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
                                        pageBuilder: (_, __, ___) => Signup(),
                                        transitionDuration: const Duration(seconds: 0),
                                      ),
                                    );
                                    print(MediaQuery.of(context).size.width);
                                  },
                                  child: const Text(
                                    "Register here!",
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
                                setState(() {
                                  email = val;
                                  validate_Email = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(email);
                                  ;
                                  print(validate_Email);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter your emailId',
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
                                counterText: 'Forgot password?',
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


                            SizedBox(height: 40),

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
                                  if(password != "" && email !="" && validate_Email == true){
                                    try {
                                      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                          email: email,
                                          password: password
                                      );
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        print('No user found for that email.');
                                      } else if (e.code == 'wrong-password') {
                                        print('Wrong password provided for that user.');
                                      }
                                    }
                                    final token = await _auth.currentUser?.getIdToken();
                                    dio.options.headers["Authorization"] = "Bearer $token";
                                    print("TOKEN : $token");
                                    var _response = await dio.post("${baseUrl}/users/signin");

                                    if(_response.statusCode == 404){
                                      //onboard
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Onboard()));
                                    }
                                    if(_response.statusCode == 200){
                                      //Dashboard
                                      ToastFun("Login Success!!");
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Dashboard()));
                                    }
                                  }
                                  else if(password == ""){
                                    ToastFun("Please Enter Password!!");
                                  }
                                  else if(email == ""){
                                    ToastFun("Please Enter EmailId !!");
                                  }
                                  else if(validate_Email == false){
                                    ToastFun("Please Verify Your EmailId!!");
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
                                    child: Center(child: Text("Sign In"))),
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
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
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
