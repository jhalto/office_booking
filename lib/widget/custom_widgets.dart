
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

class customTextFromField extends StatelessWidget {
  String hintText;
  TextEditingController controller;
  FormFieldValidator? validator;
  customTextFromField({
    super.key,required this.hintText,required this.controller, this.validator
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(

        hintText: hintText,

        enabledBorder: OutlineInputBorder(

          borderSide: BorderSide(
              width: 3,
              color: Colors.black12
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        border: OutlineInputBorder(
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Colors.blueAccent,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
