import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

const baseUrl = "http://ec2-16-171-181-186.eu-north-1.compute.amazonaws.com:5000";

var companyName;
var companyCredits;
var companyId;

var selectedTemplateId;
var selectedTemplateData;
List selectedRecipients = [];
int selectedTab = 0;

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


