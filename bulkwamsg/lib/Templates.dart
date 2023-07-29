import 'package:bulkwamsg/widgets.dart';
import 'package:dio/dio.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'GlobalVariables.dart';

class Templates extends StatefulWidget {
  const Templates({Key? key}) : super(key: key);

  @override
  State<Templates> createState() => _TemplatesState();
}

class _TemplatesState extends State<Templates> {
  final _messageTextController = TextEditingController();
  final _templateTitleTextController = TextEditingController();
  bool hideIcons = true;
  var oldTemplates = [];
  Dio dio = new Dio();
  PlatformFile? _imageFile;


  Future<void> _pickImage() async {
    try {
      // Pick an image file using file_picker package
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      // If user cancels the picker, do nothing
      if (result == null) return;

      // If user picks an image, update the state with the new image file
      setState(() {
        _imageFile = result.files.first;
      });
    } catch (e) {
      // If there is an error, show a snackbar with the error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }


  fetchTemplates() async {
    final token = await getToken();
    dio.options.headers["Authorization"] = "Bearer $token";
    print("TOKEN : $token");
    var response = await dio.get("${baseUrl}/companies/$companyId/message-templates", data: {});
    if(response.statusCode == 200){
     setState(() {
       oldTemplates = response.data;
     });
    }
    else{
      ToastFun("Unable to fetch old template");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTemplates();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Select a template", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),),
                Divider(),
                for(int i=0; i<oldTemplates.length; i++)...[
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        selectedTemplateId = oldTemplates[i]["template_id"];
                        selectedTemplateData = oldTemplates[i];
                        // oldTemplates[i]["selected"] = true;
                      });
                    },
                    child: ListTile(
                      leading: IconButton(
                        onPressed: (){},
                        icon: oldTemplates[i]["template_id"] == selectedTemplateId ? Icon(Icons.check_circle, color: Colors.green,):Icon(Icons.check_circle_outline),
                      ),
                      title: Text(oldTemplates[i]["template_name"]),
                      subtitle:  Card(
                        elevation: 2,
                        color: Colors.white,
                        child: Wrap(
                          alignment: WrapAlignment.start,
                          children: <Widget>[


                            Column(
                              children: [
                                oldTemplates[i]["attachment_filename"]!=null ?
                                Padding(padding:const EdgeInsets.all(8.0),
                                  child: Image.network("${baseUrl}/static/${oldTemplates[i]["attachment_filename"]}".replaceAll(" ","%20")
                                  ),
                                ): SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(oldTemplates[i]["message_template"]),
                                ),
                              ],
                            ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("10:00 PM",textAlign: TextAlign.end, style: TextStyle(color: Colors.grey),),
                                  ),
                                ],
                            ),
                          ],
                        ),
                      ),

                      // CustomCard(msg: oldTemplates[i]["message_template"],),
                    ),
                  )
                ]
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: oldTemplates.length,
                //     itemBuilder: (context, i){
                //      ListTile(
                //        title: Text(oldTemplates[i]["template_name"]),
                //        subtitle: Text(oldTemplates[i]["message_template"]),
                //      )
                //     },
                //   ),
                // ),
              ],
            ),
          ),),
          Expanded(child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Create a template", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),),
                Divider(),
                SizedBox(height: 20,),
                TextField(
                  controller: _templateTitleTextController,
                  decoration: InputDecoration(
                    hintText: 'Title for your template',
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
                SizedBox(height: 20,),
                if (_imageFile != null)
                  Image.memory(
                    Uint8List.fromList(_imageFile!.bytes!),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                SizedBox(height: 20,),
                TextField(
                  controller: _messageTextController,
                  minLines: 10,
                  maxLines: 20,
                  onChanged: (val){

                  },
                  decoration: InputDecoration(
                    hintText: 'Your Message',
                    filled: true,
                    fillColor: Colors.blueGrey[50],
                    labelStyle: TextStyle(fontSize: 12),
                    contentPadding: EdgeInsets.only(left: 30, right: 30, top: 30),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        hideIcons = !hideIcons;
                      });
                    }, icon: Icon(Icons.emoji_emotions_rounded)),
                    IconButton(onPressed: _pickImage,
                        icon: Icon(Icons.image))

                  ],
                ),
                  !hideIcons ? Container(
                    color: Colors.lightBlue,
                    height: 300,
                    child: EmojiPicker(
                        textEditingController: _messageTextController,
                        config: const Config(
                          columns: 7,
                          emojiSizeMax: 32 * (1.0),
                        )
                    ),
                  ) : SizedBox(),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: () async {

                  final token = await getToken();
                  dio.options.headers["Authorization"] = "Bearer $token";
                  print("TOKEN : $token");

                  var response;
                  if(_imageFile!=null){
                    var uploadfile = _imageFile?.bytes;
                    String? fileName = _imageFile?.name;
                    FormData formData = FormData.fromMap({
                      'attachment': await MultipartFile.fromBytes(uploadfile!,filename: fileName, ),
                      "templateName": _templateTitleTextController.text,
                      "messageTemplate": _messageTextController.text,

                    });
                     response = await dio.post("${baseUrl}/companies/$companyId/message-templates",
                        data: formData
                    );
                  }
                  else{
                    response = await dio.post("${baseUrl}/companies/$companyId/message-templates",
                        data: {
                          "templateName": _templateTitleTextController.text,
                          "messageTemplate": _messageTextController.text,
                        }
                    );
                  }



                  if(response.statusCode == 200){
                    ToastFun("Template saved !!!");
                    setState(() {
                      _messageTextController.text = "";
                      _templateTitleTextController.text = "";
                    });
                    fetchTemplates();
                  }
                  else{
                    ToastFun("Oops Template not saved !!!");
                  }
                }, child: const Text("Save Template"))
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// class CustomCard extends StatelessWidget {
//
//
//   final String msg;
//   final String additionalInfo;
//
//   CustomCard({
//     required this.msg,
//     this.additionalInfo = ""
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Stack(
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: RichText(
//               text: TextSpan(
//                 children: <TextSpan>[
//
//                   //real message
//                   TextSpan(
//                     text: "$msg    ",
//                     // style: Theme.of(context).textTheme.subtitle,
//                   ),
//
//                   //fake additionalInfo as placeholder
//                   TextSpan(
//                       text: additionalInfo,
//                       style: const TextStyle(
//                           color: Color.fromRGBO(255, 255, 255, 1)
//                       )
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           //real additionalInfo
//           Positioned(
//             right: 8.0,
//             bottom: 4.0,
//             child: Text(
//               additionalInfo,
//               style: const TextStyle(
//                 fontSize: 12.0,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }