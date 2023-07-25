import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

const baseUrl = "http://ec2-13-51-150-73.eu-north-1.compute.amazonaws.com:5000";

var companyName;
var companyCredits;
var companyId;

var selectedTemplateId;

class URLS{
  String userSignin = "$baseUrl/users/signin";
  String userSignup = "$baseUrl/users/signup";
  String userCompanies = "$baseUrl/users/companies";
  String processFile = "$baseUrl/process-file";
  String createCompany = "$baseUrl/companies";
}

final FirebaseAuth _auth = FirebaseAuth.instance;

getToken() async {
  final token = await _auth.currentUser?.getIdToken();
  return token;
}


