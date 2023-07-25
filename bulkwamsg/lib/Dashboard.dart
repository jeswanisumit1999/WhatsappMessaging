import 'package:bulkwamsg/LoginPage.dart';
import 'package:bulkwamsg/widgets.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Dio dio = new Dio();
  final baseUrl = "http://ec2-13-51-150-73.eu-north-1.compute.amazonaws.com:5000";
  var companyDetails;
  String message = "";
  int _currentStep = 0;
  var recipents = [];
  StepperType stepperType = StepperType.vertical;
  getCompanyDetils() async {
    final token = await _auth.currentUser?.getIdToken();
    dio.options.headers["Authorization"] = "Bearer $token";
    print("TOKEN : $token");
    var _response = await dio.get("${baseUrl}/users/companies");

    if(_response.statusCode == 404){
      //onboard
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Onboard()));
    }
    if(_response.statusCode == 200){
      print(_response.data);
      setState(() {
        companyDetails = _response.data;
      });
      //Dashboard
      // ToastFun("Login Success!!");
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getCompanyDetils();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.person, color: Colors.green,),
            SizedBox(width: 10,),
            companyDetails == null ? CircularProgressIndicator() : Text(companyDetails[0]["name"].toString(), style: TextStyle(fontSize: 16),)
          ],
        ),
        actions: [
          IconButton(onPressed: (){
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Logout?'),
                  content: const Text('Are you sure you want to logout'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: (){
                    _auth.signOut();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()));
                    },
                      child: const Text('Yes'),
                    ),
                  ],
                )
            );
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: companyDetails!=null,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.mark_chat_read_outlined, color: Colors.green,),
                      const SizedBox(width: 10,),
                      companyDetails == null ? const CircularProgressIndicator() : Text(companyDetails[0]["credits"].toString(), style: TextStyle(fontSize: 16),)
                    ],
                  )
              ),
              
              Stepper(
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue:  continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                Step(
                  title: Text("Login to Account",),
                  content: Container(height: 100, width: 100, color: Colors.black12,child: Text("QR Code Here",))
                ),
                Step(
                    title: Text("Design your message",),
                    content: Container(color: Colors.black12,child:TextField(
                      minLines: 10,
                      maxLines: 15,
                      onChanged: (val){
                        setState(() {
                          message = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter message',
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
                    ),)
                ),
                    Step(
                    title: Text("Choose resipents",),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            /// Use FilePicker to pick files in Flutter Web

                            FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['xlsx', 'csv'],
                              allowMultiple: false,
                            );

                            if (pickedFile != null) {
                              print("file picked");
                              print(pickedFile);

                              var uploadfile = pickedFile.files.single.bytes;
                              print(uploadfile);
                              String fileName = pickedFile.files.single.name;
                              print(fileName);
                              print("Data fromMap");
                              FormData formData = FormData.fromMap({
                                'file':
                                await MultipartFile.fromBytes(uploadfile!,filename: fileName ),
                              });
                              try {
                                print("Post request");
                                final token = await _auth.currentUser?.getIdToken();
                                dio.options.headers["Authorization"] = "Bearer $token";
                                print("token");
                                print("sending response");
                                Response response = await dio.post(
                                  '$baseUrl/process-file', // Replace with your API endpoint
                                  data: formData,
                                );
                                print(response.data);

                                if (response.statusCode == 200) {
                                  setState(() {
                                    print('File uploaded successfully!');
                                    recipents = response.data;
                                    ToastFun("Processed file");
                                  });
                                } else {
                                  setState(() {
                                    print("'File upload failed. Status code: ${response.statusCode}'");
                                  });
                                }
                              } catch (e) {
                                setState(() {
                                  print('Error uploading file: $e');
                                  ToastFun("Unable to process file");
                                });
                              }
                            }
                          },
                          child: Text("Pick file"),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Container(
                                    color: Colors.black12,
                                    height: MediaQuery.of(context).size.height/2,
                                    child: recipents.length == 0 ? const Center(child: Text("No recipients found"),):
                                    ListView.builder(
                                        itemCount: recipents.length,
                                        itemBuilder: (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: (){
                                              if(recipents[index]["selected"] == null ||  recipents[index]["selected"] == true){
                                                setState(() {
                                                  recipents[index]["selected"] = false;
                                                });
                                              }
                                              else{
                                                setState(() {
                                                  recipents[index]["selected"] = true;
                                                });
                                              }
                                            },
                                            child: ListTile(
                                                leading: (recipents[index]["selected"] == null ||  recipents[index]["selected"] == true) ? Icon(Icons.check_circle, color: Colors.green,) : Icon(Icons.check_circle_outline),
                                                title: Text(recipents[index]["name"]),
                                                subtitle: Text(recipents[index]["mobileNumber"])),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )

                ),
                Step(
                    title: Text("Send",),
                    content: ElevatedButton(onPressed: () {  },
                      child: ElevatedButton(
                        onPressed: () async {
                          /// Use FilePicker to pick files in Flutter Web

                          FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['xlsx', 'csv'],
                            allowMultiple: false,
                          );

                          if (pickedFile != null) {
                            print("file picked");
                            print(pickedFile);

                            var uploadfile = pickedFile.files.single.bytes;
                            print(uploadfile);
                            String fileName = pickedFile.files.single.name;
                            print(fileName);
                            print("Data fromMap");
                            FormData formData = FormData.fromMap({
                              'file':
                              await MultipartFile.fromBytes(uploadfile!,filename: fileName ),
                            });
                            try {
                              print("Post request");
                              final token = await _auth.currentUser?.getIdToken();
                              dio.options.headers["Authorization"] = "Bearer $token";
                              print("token");
                              print("sending response");
                              Response response = await dio.post(
                                '$baseUrl/process-file', // Replace with your API endpoint
                                data: formData,
                              );
                              print(response.data);

                              if (response.statusCode == 200) {
                                setState(() {
                                  print('File uploaded successfully!');
                                });
                              } else {
                                setState(() {
                                  print("'File upload failed. Status code: ${response.statusCode}'");
                                });
                              }
                            } catch (e) {
                              setState(() {
                                print('Error uploading file: $e');
                                ToastFun("Unable to process file");
                              });
                            }
                          }
                        },
                        child: Text("Pick file"),
                      ),
                    )
                )
              ])

            ],
          ),
        )
      ),
    );
  }
  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued(){
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
  }
  cancel(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
  }
}
