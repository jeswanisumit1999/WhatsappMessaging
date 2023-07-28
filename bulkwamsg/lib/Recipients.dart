import 'dart:convert';

import 'package:bulkwamsg/widgets.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GlobalVariables.dart';

class Recipients extends StatefulWidget {
  const Recipients({Key? key}) : super(key: key);

  @override
  State<Recipients> createState() => _RecipientsState();
}

class _RecipientsState extends State<Recipients> {
  Dio dio = new Dio();
  var savedRecipients;
  final newMobileNumber = TextEditingController();
  final newRecipientName = TextEditingController();

  getCompanyRecipients() async {
    final token = await getToken();
    dio.options.headers["Authorization"] = "Bearer $token";
    print("TOKEN : $token");
    var response = await dio.get("${baseUrl}/companies/$companyId/recipients", data: {});
    if(response.statusCode == 200){
      setState(() {
        savedRecipients = response.data;
      });
    }
    else{
      ToastFun("Unable to fetch saved recipients");
    }
  }
  saveRecipients(recipientsList) async {
    final token = await getToken();
    dio.options.headers["Authorization"] = "Bearer $token";
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var data = json.encode(recipientsList);
      var dio = Dio();
      var response = await dio.request(
        '$baseUrl/companies/$companyId/recipients',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
        data: data,
      );

      if (response.statusCode == 200) {
        print(json.encode(response.data));
        ToastFun("${recipientsList.length} Recipients saved");
        getCompanyRecipients();
      }
      else {
        print(response.statusMessage);
        ToastFun("Something went wrong");
      }
    } catch (e) {
      ToastFun("ERROR: $e");
      print("ERROR: $e");
    }
  }
  pickFileAndGetRecipients() async {
    // Pick file
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
      allowMultiple: false,
    );

    var uploadfile = pickedFile?.files.single.bytes;
    String? fileName = pickedFile?.files.single.name;
    FormData formData = FormData.fromMap({
      'file':
      await MultipartFile.fromBytes(uploadfile!,filename: fileName ),
    });

    // upload file to get Recipients
    try {
      final token = await getToken();
      dio.options.headers["Authorization"] = "Bearer $token";
      Response response = await dio.post(
        '$baseUrl/process-file', // Replace with your API endpoint
        data: formData,
      );
      print("$baseUrl/process-file : Status Code ${response.statusCode}");
      if (response.statusCode == 200) {
        var importedRecipients = response.data;
        print(importedRecipients);
        var uniqueRecipients = [];
        for (var recipient in importedRecipients) {
          if (checkRecipientAlreadyPresent(recipient["mobileNumber"]) ==
              false) {
            uniqueRecipients.add({
              "name": recipient["name"],
              "contactMedium": "WhatsApp",
              "contactInformation": recipient["mobileNumber"]
            });
          }
        }
        print(uniqueRecipients);
        saveRecipients(uniqueRecipients);
      }
    } catch(e){
      ToastFun("error occurred while processing file");
      print("ERROR : $e");
    }
  }

  checkInSelectedRecipients(mobileNumber){
    if(savedRecipients != null){
      for(var recipient in selectedRecipients){
        if (recipient["contact_information"] == mobileNumber){
          return true;
        }
      }
      return false;
    }
  }

  checkRecipientAlreadyPresent(mobileNumber){
    for(var recipient in savedRecipients){
      if (recipient["contact_information"] == mobileNumber){
        return true;
      }
    }
    return false;
  }

  deleteRecipient(deleteList) async {
    var deleteRecipientIds = [];
    for(var recipient in deleteList){
      deleteRecipientIds.add(recipient["recipient_id"]);
    }
    print(deleteRecipientIds);
    final token = await getToken();
    // dio.options.headers["Authorization"] = "Bearer $token";
    // print("TOKEN : $token");
    // var response = await dio.delete("${baseUrl}/recipients", data: {
    //   "recipientIds":deleteRecipientIds
    // });
    // if(response.statusCode == 200){
    //   setState(() {
    //     for(var recipientId in deleteRecipientIds){
    //       selectedRecipients.removeWhere((element) => element["recipient_id"] == recipientId);
    //       savedRecipients.removeWhere((element) => element["recipient_id"] == recipientId);
    //     }
    //   });
    //   ToastFun("${deleteRecipientIds.length} Recipient(s) Deleted");
    // }
    // else{
    //   ToastFun("Unable to fetch saved recipients");
    // }

    try {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var data = json.encode({
        "recipientIds": deleteRecipientIds
      });
      var dio = Dio();
      var response = await dio.request(
        '$baseUrl/recipients',
        options: Options(
          method: 'DELETE',
          headers: headers,
        ),
        data: data,
      );
      print(response.data);
      if (response.statusCode == 200) {
        print(json.encode(response.data));
        ToastFun("${deleteRecipientIds.length} Recipients deleted");
        setState(() {
          selectedRecipients = [];
          getCompanyRecipients();
        });
      }
      else {
        print(response.statusMessage);
        ToastFun("Something went wrong");
      }
    } catch (e) {
      ToastFun("ERROR: $e");
      print("ERROR: ${e.toString()}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCompanyRecipients();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        // Expanded(child:SavedRecipientsWidget()),
        // Expanded(child: options()),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text("Saved Recipients", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),),
                optionButtons(),
                Expanded(child:SavedRecipientsWidget()),
              ],
            ),
          ),
        ),
        Expanded(child: Column(
          children: [
            Text("Add Recipents", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),),
            Expanded(child: options()),
          ],
        ))
      ],
    );
  }
  optionButtons(){
    return Row(
      children: [
        Expanded(child: ElevatedButton(onPressed: (){
          setState(() {
            selectedRecipients = [];
            for(var recipient in savedRecipients){
              selectedRecipients.add(recipient);
            }
          });
        }, child: Text("Select All"))),
        selectedRecipients.isNotEmpty ? Expanded(child: ElevatedButton(onPressed: (){
          setState(() {
            selectedRecipients = [];
          });
        }, child: Text("Unselect All"))):Container(),
        selectedRecipients.isNotEmpty ? Expanded(child: ElevatedButton(onPressed: (){
          deleteRecipient(selectedRecipients);
        }, child: Text("Delete Selected"),)):Container(),
      ],
    );
  }

  options(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Import recipients from file", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
          Text("Note : Please use xlxs or csv file which contains name and mobile numbers of recipients", style: TextStyle(fontSize: 14),),
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: () async {
                pickFileAndGetRecipients();
                // if (pickedFile != null) {
                //   print("file picked");
                //   print(pickedFile);
                //
                //   try {
                //     print("Post request");
                //
                //     print(response.data);
                //
                //     if (response.statusCode == 200) {
                //       setState(() async {
                //         print('File uploaded successfully!');
                //         var importedRecipents = response.data;
                //         var uniqueRecipents = [];
                //         for(var recipient in importedRecipents){
                //           if(await checkRecipientAlreadyPresent(recipient["contact_information"])){
                //             uniqueRecipents.add(recipient);
                //           }
                //         }
                //
                //         response = await dio.post(
                //           '$baseUrl/process-file', // Replace with your API endpoint
                //           data: formData,
                //         );
                //         for(int i=0; i<uniqueRecipents.length; i++){
                //           uniqueRecipents[i]["contactMedium"] = "WhatsApp";
                //           uniqueRecipents[i]["contactInformation"] = uniqueRecipents[i]["mobileNumber"];
                //         }
                //         try{
                //           var response = await dio.post("${baseUrl}/companies/$companyId/recipients", data: {
                //             {uniqueRecipents}
                //           });
                //           if(response.statusCode == 200){
                //             ToastFun("${uniqueRecipents.length} recipients Imported Successfully");
                //             setState(() {
                //               savedRecipients = response.data;
                //             });
                //           }
                //           else{
                //             ToastFun("Unable to fetch saved recipients");
                //           }
                //         }catch(e){
                //           print("ERROR : " + e.toString());
                //         }
                //         ToastFun("Processed file");
                //       });
                //     } else {
                //       setState(() {
                //         print("'File upload failed. Status code: ${response.statusCode}'");
                //       });
                //     }
                //   } catch (e) {
                //     setState(() {
                //       print('Error uploading file: $e');
                //       ToastFun("Unable to process file");
                //     });
                //   }
                // }
              }, child: Text("Select file")),),
            ],
          ),
          SizedBox(height: 20,),
          Divider(),
          SizedBox(height: 20,),
          Text("Add a recpient", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),),
          SizedBox(height: 10,),
          // Row(
          //   children: [
          //     Text("Name "),
              TextField(
                controller: newRecipientName,
                onChanged: (val){
                  setState(() {

                  });
                },
                decoration: InputDecoration(
                  hintText: 'Name',
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
          //   ],
          // ),
          SizedBox(height: 10,),
          // Row(
          //   children: [
          //     Text("Name "),
              TextField(
                controller: newMobileNumber,
                onChanged: (val){
                  setState(() {

                  });
                },
                decoration: InputDecoration(
                  hintText: 'Mobile No.',
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
          //   ],
          // )
          SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: ElevatedButton(onPressed: (){
                saveRecipients([
                  {
                    "name": newRecipientName.text,
                    "contactMedium": "WhatsApp",
                    "contactInformation": newMobileNumber.text
                  }
                ]);
                setState(() {
                  newMobileNumber.text = "";
                  newRecipientName.text = "";
                });
              }, child: Text("Add"))),
            ],
          )
        ],
      ),
    );
  }
  SavedRecipientsWidget(){
    return savedRecipients != null ? ListView.builder(
        itemCount: savedRecipients.length,
        itemBuilder: (BuildContext context, int index){
          return GestureDetector(
              onTap: (){
                if (checkInSelectedRecipients(savedRecipients[index]["contact_information"])){
                  setState(() {
                    selectedRecipients.removeWhere((element)=>element["contact_information"] == savedRecipients[index]["contact_information"]);
                  });

                }
                else{
                  setState(() {
                    selectedRecipients.add(savedRecipients[index]);
                  });

                }
                print(savedRecipients);
              },
            child: ListTile(
                leading: checkInSelectedRecipients(savedRecipients[index]["contact_information"]) ? Icon(Icons.check_circle, color: Colors.green,) : Icon(Icons.check_circle_outline),
                title:  Text(
                  savedRecipients[index]["name"],
                  // style: TextStyle(color: Colors.green, fontSize: 15),
                ),
              trailing: Text(savedRecipients[index]["contact_information"]),
              // trailing: Icon(Icons.delete_outlined, color: Colors.grey,),
            ),

          );
        }
    ) : const SizedBox();
  }
}

// class SavedRecipientsWidget extends StatefulWidget {
//   const SavedRecipientsWidget({Key? key}) : super(key: key);
//
//   @override
//   State<SavedRecipientsWidget> createState() => _SavedRecipientsWidgetState();
// }
//
// class _SavedRecipientsWidgetState extends State<SavedRecipientsWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }
