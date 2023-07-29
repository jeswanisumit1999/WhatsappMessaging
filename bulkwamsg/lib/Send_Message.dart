

import 'package:bulkwamsg/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'GlobalVariables.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr/qr.dart';


class SendMessage extends StatefulWidget {
  SendMessage({Key? key, required this.selectedTab}) : super(key: key);
  var selectedTab;
  @override
  _SendMessageState createState() => _SendMessageState();
}


class _SendMessageState extends State<SendMessage> {
  Dio dio = new Dio();
  var QrText;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Preview()),
        Expanded(child: startSending()),
      ],
    );
  }

  Preview(){
     return Column(
      children: [
        Text("Preview", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),),
        Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            selectedTemplateData == null ? TextButton(onPressed: (){
              setState(() {
                widget.selectedTab  = 0;
              });
            }, child: const Text("⚠️ You haven selected any message template", style: TextStyle(color: Colors.red),)):
            Column(
              children: [
                Card(
                  elevation: 2,
                  color: Colors.white,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(selectedTemplateData["message_template"]),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Just Now",textAlign: TextAlign.end, style: TextStyle(color: Colors.grey),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: (){
                      setState(() {
                        widget.selectedTab = 0;
                      });
                    }, child: const Text("Change Template"))
                  ],
                ),
              ],
            ),
            selectedRecipients.isEmpty ? TextButton(onPressed: (){},child: const Text("⚠️ You haven selected any recipient", style: TextStyle(color: Colors.red),)) :
            Text("${selectedRecipients.length} recipients selected", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.green),)
          ],
        )
      ],
    );
  }
  startSending(){
    return const Column(
      children: [
        Text("Generate QR", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),),
        Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
          ],
        )
      ],
    );
  }
}

// Widget temp(){
//   return Container(
//       height: 800,
//       width: 1000,
//       child:MediaQuery.of(context).size.width >= 800? Row(
//         children: [
//           Expanded(
//             child: Column(
//               children: [
//                 ListTile(
//                   title: Card(
//                     elevation: 2,
//                     color: Colors.white,
//                     child: Wrap(
//                       alignment: WrapAlignment.start,
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(selectedTemplateData["message_template"]),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.all(8.0),
//                               child: Text("10:00 PM",textAlign: TextAlign.end, style: TextStyle(color: Colors.grey),),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(onPressed: (){
//                   setState(() {
//                     selectedTab = 0;
//                   });
//                 },
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   child: const SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: Center(child: Text("Change Template"))),
//
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 ListTile(
//                   title: Text("Generate QR to Login"),
//                   subtitle: TextButton(
//                     onPressed: () async {
//                       //send TemplateId and RecepientsId to API
//                       var templateId = selectedTemplateData["template_id"];
//                       var recipentsId = [
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//                         "ca7a4049-3f5b-4598-91dc-c5e82f9b75a3",
//
//                       ];
//
//                       print(recipentsId);
//                       print(templateId);
//                       final token = await getToken();
//                       try{
//                         dio.options.headers["Authorization"] = "Bearer $token";
//                         print("TOKEN : $token");
//                         var response = await dio.post("${baseUrl}/companies/queue-message",
//                             data: {
//                               "recipient_ids":recipentsId,
//                               "template_id":templateId,
//                             });
//                         print(response.statusCode);
//                         if(response.statusCode == 200){
//                           setState(() {
//                             QrText = response.data;
//                           });
//                         }
//                         else{
//                           ToastFun("Unable to fetch old template");
//                         }
//                       } catch(e){
//                         print(e);
//                       }
//
//
//
//                     },
//                     child: Text("Generate"),
//                   ),
//                 ),
//
//                 QrText!=null ? PrettyQr(
//                   //image: AssetImage('images/twitter.png'),
//                   //typeNumber: 3,
//                   size: 100,
//                   data: QrText,
//                   errorCorrectLevel: QrErrorCorrectLevel.M,
//                   roundEdges: true,
//                 ):SizedBox(),
//
//               ],
//             ),
//           ),
//         ],
//       ):Column(
//         children: [
//           ListTile(
//             title: Card(
//               elevation: 2,
//               color: Colors.white,
//               child: Wrap(
//                 alignment: WrapAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(selectedTemplateData["message_template"]),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text("10:00 PM",textAlign: TextAlign.end, style: TextStyle(color: Colors.grey),),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           ElevatedButton(onPressed: (){
//             setState(() {
//               selectedTab = 0;
//             });
//           },
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//             ),
//             child: const SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: Center(child: Text("Change Template"))),
//
//           ),
//
//           ListTile(
//             title: Card(
//               elevation: 2,
//               color: Colors.white,
//               child: Wrap(
//                 alignment: WrapAlignment.start,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(selectedTemplateData["message_template"]),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Text("10:00 PM",textAlign: TextAlign.end, style: TextStyle(color: Colors.grey),),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       )
//   );
// }