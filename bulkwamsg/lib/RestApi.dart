//
// import 'package:dio/dio.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// Dio dio = new Dio();
// const baseUrl = "http://ec2-16-170-205-112.eu-north-1.compute.amazonaws.com:5000/";
//
//
// final FirebaseAuth _auth = FirebaseAuth.instance;
//
// // Get Requests
// getUser() async {
//   final token = await _auth.currentUser?.getIdToken();
//   print("TOKEN : $token");
//   // dio.options.headers['content-Type'] = 'application/json';
//   var data = {};
//   dio.options.headers["Authorization"] = "Bearer $token";
//   var _response = await dio.get("${baseUrl}company", data: data);
//   return {
//     "status": response.
//   };
//   print(response);
// }
//
