
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

myStyle([double? size,Color? color,FontWeight? fw]){
  return GoogleFonts.roboto(
    fontSize: size,
    color: color,
    fontWeight: fw,
  );
}
var spinkit = SpinKitSpinningLines(
   color: Colors.red,
);

 showToastMessage (String text) {
   Fluttertoast.showToast(
       msg: text,
       toastLength: Toast.LENGTH_SHORT,
       gravity: ToastGravity.CENTER,
       timeInSecForIosWeb: 1,
       backgroundColor: Colors.red,
       textColor: Colors.white,
       fontSize: 16.0
   );
 }
class customButton extends StatelessWidget {
   String? text;
   VoidCallback? onPressed;
   customButton({required this.text,required this.onPressed});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ElevatedButton(
      child: Text('$text',style: myStyle(18,Colors.white),),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: Size(double.infinity, 50),
      ),
      onPressed: onPressed,


    );
  }
}
class customTextFromField extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  FormFieldValidator? validator;
  TextInputType? inputType;
  Decoration? decoration;


  customTextFromField({
    super.key,required this.hintText,required this.controller, this.validator, this.inputType,this.decoration
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      controller: controller,
      validator: validator,
      decoration: InputDecoration(

        hintText: hintText,

        enabledBorder: OutlineInputBorder(

          borderSide: BorderSide(
              width: 3,
              color: Colors.black12
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        border: OutlineInputBorder(
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Colors.blueAccent,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
class customTextField extends StatelessWidget {
  String hintText;
  TextEditingController controller;

  TextInputType? inputType;
  Decoration? decoration;


  customTextField({
    super.key,required this.hintText,required this.controller, this.inputType,this.decoration
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: inputType,
      controller: controller,

      decoration: InputDecoration(

        hintText: hintText,

        enabledBorder: OutlineInputBorder(

          borderSide: BorderSide(
              width: 3,
              color: Colors.black12
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        border: OutlineInputBorder(
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Colors.blueAccent,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }
}
titleBold(){
   return TextStyle(
     fontWeight: FontWeight.bold,
     fontSize: 25,
   );
}
headingBold(){
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
}
subHeadingBold(){
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
}
buttonRegular(){
   return TextStyle(
     fontSize: 15,
   );
}
bodyLight(){
   return TextStyle(
     fontSize: 14,
     color: Colors.white
   );
}
bodyBold(){
   return TextStyle(
     fontSize: 14,
     fontWeight: FontWeight.bold,
   );
}
tagsRegular(){
   return TextStyle(
     fontSize: 12
   );
}
small(){
   return TextStyle(
     fontSize: 10,
   );
}
final Color maya = Color(0xff6DCEF5);
final Color caya = Color(0xff28768E);
final Color sada = Color(0xffFFFFFF);
final Color kala = Color(0xff000000);

whiteStyle(){
  return TextStyle(
    color: Colors.white
  );
}