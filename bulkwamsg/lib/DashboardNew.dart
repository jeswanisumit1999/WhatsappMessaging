import 'package:bulkwamsg/GlobalVariables.dart';
import 'package:bulkwamsg/Recipients.dart';
import 'package:bulkwamsg/Send_Message.dart';
import 'package:bulkwamsg/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Templates.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Dio dio = new Dio();
  bool companyDtailsLoader = true;

  getCompanyDetails() async {
    final token = await getToken();
    dio.options.headers["Authorization"] = "Bearer $token";
    print("TOKEN : $token");
    var response = await dio.get("${baseUrl}/users/companies");
    if(response.statusCode == 200){
      companyName = response.data[0]["name"];
      companyCredits = response.data[0]["credits"];
      companyId = response.data[0]["company_id"];
      print("COMPANY DETAILS : ${response.data}");
    }
    else if(response.statusCode == 400){
      ToastFun("Unable to get details, Try sign-in again");
    }
    setState(() {
      companyDtailsLoader = false;
    });
  }
  void initState() {
    super.initState();
    // TODO: implement initState
    getCompanyDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width/4,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.green,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("WA Bulk Sender", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  SizedBox(height: 20,),
                  const Divider(),
                  const SizedBox(height: 20,),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.message, color: Colors.white,),
                      SizedBox(width: 10,),
                      TextButton(onPressed: (){
                        setState(() {
                          selectedTab = 0;
                        });
                      }, child: const Text("Message Templates", style: TextStyle(color: Colors.white, fontSize: 20),)),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.people, color: Colors.white),
                      SizedBox(width: 10,),
                      TextButton(onPressed: (){
                        setState(() {
                          selectedTab = 1;
                        });
                      }, child: const Text("Select Recipients", style: TextStyle(color: Colors.white, fontSize: 20),)),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.send, color: Colors.white),
                      const SizedBox(width: 10,),
                      TextButton(onPressed: (){
                        setState(() {
                          selectedTab = 2;
                        });
                      }, child: const Text("Send Message", style: TextStyle(color: Colors.white, fontSize: 20),)),
                    ],
                  ),
                  Divider(),
                ],
              ),
            ),
          ),
          Expanded(child:
          !companyDtailsLoader ? Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/pxfuel.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.height,
            child: selectedTab == 0 ? Templates() : selectedTab == 1 ? Recipients() : selectedTab == 2 ? SendMessage() : SizedBox(),
          ): const Center(child: CircularProgressIndicator()))
        ],
      ),
    );
  }
}
