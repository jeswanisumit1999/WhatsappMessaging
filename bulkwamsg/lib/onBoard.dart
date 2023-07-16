import 'package:bulkwamsg/Dashboard.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Onboard extends StatefulWidget {
  const Onboard({Key? key}) : super(key: key);

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String email = "";
  String companyName = "";
  String description = "";
  String phoneNumber = "";

  Dio dio = new Dio();
  final baseUrl = "http://ec2-16-170-205-112.eu-north-1.compute.amazonaws.com:5000/";


  @override
  Widget build(BuildContext context){
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
                                  companyName = val;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Name of your company',
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
                                  description = val;
                                },
                                decoration: InputDecoration(
                                  hintText: 'What is it about ... (description)',
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
                              SizedBox(height: 40),

                              TextField(
                                onChanged: (val){
                                  phoneNumber = val;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Primary phone number',
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
                                    final token = await _auth.currentUser?.getIdToken();
                                    print("TOKEN : $token");
                                    dio.options.headers["Authorization"] = "Bearer $token";
                                    // print("TOKEN : $token");
                                    var email = (await _auth.currentUser!.email)!;
                                    var response = await dio.post("${baseUrl}companies", data: {
                                      "name": companyName,
                                      "description": description,
                                      "primaryEmail": email,
                                      "primaryPhoneNumber": phoneNumber
                                    });
                                    print(response.statusCode);
                                    print(response.data);
                                    if(response.statusCode == 201){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Dashboard()));
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
