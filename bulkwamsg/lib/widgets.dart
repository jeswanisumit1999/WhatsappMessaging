import 'package:fluttertoast/fluttertoast.dart';

ToastFun(String msg){
  Fluttertoast.showToast(
      msg: msg,
      webShowClose: true,
      webPosition: "right",
      toastLength: Toast.LENGTH_LONG, //duration for message to show
      gravity: ToastGravity.CENTER, //where you want to show, top, bottom
      timeInSecForIosWeb: 3, //for iOS only
      fontSize: 16.0 //message font size
  );
}