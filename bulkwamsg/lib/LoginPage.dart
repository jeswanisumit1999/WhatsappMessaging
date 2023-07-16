import 'package:bulkwamsg/Dashboard.dart';
import 'package:bulkwamsg/RestApi.dart';
import 'package:bulkwamsg/Signup.dart';
import 'package:bulkwamsg/onBoard.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Dio dio = new Dio();
  final baseUrl = "http://ec2-16-170-205-112.eu-north-1.compute.amazonaws.com:5000/";

  String email = "";
  String password = "";

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
    var currentUserDetails = _auth.currentUser;
    return user;
  }

  @override
  void initState() {
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
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Signup()));
                            signIn = false;
                            print(signIn);
                          });
                        },
                        child: _menuItem('Register', false)
                    ),
                    // _registerButton()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
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
                                  if(password != ""){
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
                                    // print("TOKEN : $token");
                                    var _response = await dio.get("${baseUrl}company", data: {});
                                    print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                                    Fluttertoast.showToast(
                                        msg: "Login Success !!!",
                                        // webShowClose: true,
                                        webPosition: "right",
                                        toastLength: Toast.LENGTH_LONG, //duration for message to show
                                        gravity: ToastGravity.CENTER, //where you want to show, top, bottom
                                        timeInSecForIosWeb: 3, //for iOS only
                                        backgroundColor: Colors.red, //background Color for message
                                        // textColor: Colors.white, //message text color
                                        fontSize: 16.0 //message font size
                                    );
                                    if(_response.statusCode == 404){
                                      //onboard
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Onboard()));
                                    }
                                    if(_response.statusCode == 200){
                                      //Dashboard
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Dashboard()));
                                    }
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
