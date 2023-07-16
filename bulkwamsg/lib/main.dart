import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'LoginPage.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDhK2Eo3ifVQeIyvTD95yHAaaXZs7BN2O4',
        appId: '1:458557238580:web:50ea3ee474b7adb0a10961',
        messagingSenderId: '458557238580',
        projectId: 'whatsapp-marketing-9',
        authDomain: 'whatsapp-marketing-9.firebaseapp.com',
        storageBucket: 'whatsapp-marketing-9.appspot.com',
        measurementId: 'G-43B41W24T8',
      )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'Flutter Login Web',
      home: Login(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class LoginPage extends StatelessWidget {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//
//   Widget Menu(){
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 30),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               _menuItem('Home', false),
//               _menuItem('About us', false),
//               _menuItem('Contact us', false),
//               _menuItem('Help', false),
//             ],
//           ),
//           // Row(
//           //   children: [
//           //     _menuItem('Sign In', true),
//           //     _menuItem('Register', false),
//           //     // _registerButton()
//           //   ],
//           // ),
//         ],
//       ),
//     );
//   }
//
//   Widget _menuItem(title, isActive){
//     return Padding(
//       padding: const EdgeInsets.only(right: 75),
//       child: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         child: Column(
//           children: [
//             Text(
//               '$title',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: isActive ? Colors.deepPurple : Colors.grey,
//               ),
//             ),
//             SizedBox(
//               height: 6,
//             ),
//             isActive
//                 ? Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//               decoration: BoxDecoration(
//                 color: Colors.deepPurple,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             )
//                 : SizedBox()
//           ],
//         ),
//       ),
//     );
//     }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFf5f5f5),
//       body: ListView(
//         padding: EdgeInsets.symmetric(
//             horizontal: MediaQuery.of(context).size.width / 8),
//         children: [
//           //Menu(),
//           MediaQuery.of(context).size.width >= 980
//               ? Menu()
//               : const SizedBox(), // Responsive
//           Body()
//         ],
//       ),
//     );
//   }
// }

// class Menu extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
//
//   Widget _menuItem({String title = 'Title Menu', isActive = false}) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 75),
//       child: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         child: Column(
//           children: [
//             Text(
//               '$title',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: isActive ? Colors.deepPurple : Colors.grey,
//               ),
//             ),
//             SizedBox(
//               height: 6,
//             ),
//             isActive
//                 ? Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: Colors.deepPurple,
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                   )
//                 : SizedBox()
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _registerButton() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey,
//             spreadRadius: 1,
//             blurRadius: 5,
//           ),
//         ],
//       ),
//       child: TextButton(
//         onPressed: (){
//
//         },
//         child:Text(
//           'Register',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: Colors.black54,
//           ),
//         ),
//       ),
//     );
//   }
// }

class Body extends StatefulWidget {

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String email = "";

  String password = "";

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

  @override
  Widget build(BuildContext context) {
    bool signIn = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap:(){
                    setState(() {
                      signIn = true;
                    });
                  },
                child: _menuItem('Sign In', signIn)),
            GestureDetector(
              onTap: (){
                setState(() {
                  signIn = false;
                });
              },
                child: _menuItem('Register', !signIn)
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
                  Text(
                    'Sign In to \nMy Application',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "If you don't have an account",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "You can",
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          print(MediaQuery.of(context).size.width);
                        },
                        child: Text(
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
                child: _formLogin(signIn),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _formLogin(signIn) {

    return Column(
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
        signIn ? Container(
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
            child: Container(
                width: double.infinity,
                height: 50,
                child: Center(child: Text("Sign In"))),
            onPressed: () async {
              // Firebase Login flutter
              try {
                final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: "emailAddress@gmail.com",
                  password: "password@123",
                );
                final FirebaseAuth _auth = FirebaseAuth.instance;
                print(await _auth.currentUser?.getIdToken());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                }
              } catch (e) {
                print(e);
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ):
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
                  email: "emailAddress@gmail.com",
                  password: "password@123",
                );
                final FirebaseAuth _auth = FirebaseAuth.instance;
                print(await _auth.currentUser?.getIdToken());
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                }
              } catch (e) {
                print(e);
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
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
                child: _loginWithButton(image: 'images/google.png')),
            //Sign in with Google
          ],
        ),
      ],
    );
  }

  Widget _loginWithButton({String? image, bool isActive = false}) {
    return Container(
      width: 90,
      height: 70,
      decoration: isActive
          ? BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 10,
                  blurRadius: 30,
                )
              ],
              borderRadius: BorderRadius.circular(15),
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey),
            ),
      child: Center(
          child: Container(
        decoration: isActive
            ? BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 2,
                    blurRadius: 15,
                  )
                ],
              )
            : BoxDecoration(),
        child: Image.asset(
          '$image',
          width: 35,
        ),
      )),
    );
  }
}
