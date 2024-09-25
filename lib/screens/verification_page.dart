import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:office_booking/screens/login_page.dart';
import 'package:office_booking/widget/custom_widgets.dart';
import 'package:http/http.dart'as http;
import '../key/api_key.dart';

class VerificationPage extends StatefulWidget {
  String email;
  VerificationPage({super.key,required this.email});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController _otpController = TextEditingController();
  String otpBy = 'email';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: otpBy,
                  items: [
                    DropdownMenuItem(
                      value: 'email',
                      child: Text('Login by Email'),
                    ),
                    DropdownMenuItem(
                      value: 'phone',
                      child: Text('Login by Phone'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      otpBy = value!;
                    });
                  },
                ),
                Text("OTP",style: myStyle(45,Colors.black45),),

                customTextFromField(hintText: "Enter your otp", controller: _otpController),

                MaterialButton(onPressed: (){
                       verifyEmail();
                },child: Text("submit"),),
              ],
            ),
          ),
        ),
      ),
    );
  }
  verifyEmail()async{
    try{
      String url = "${baseUrlDrop}verify-otp";
      var map = <String, dynamic>{};
      map['otp_by'] = otpBy;

      map['email'] = widget.email.toString();
      map['otp'] = _otpController.text.toString();
      print(widget.email);
      var response = await http.post(Uri.parse(url),body: map);
      var data = jsonDecode(response.body);
      print(response.statusCode);
      print(data);
      if(data['status']==  true){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),)).then((value) {
          setState(() {
            _otpController.clear();
          });
        },);
        showToastMessage("Successfully verified");
      }else{
        showToastMessage("Something wrong");
      }

    }catch(e){
    print(e);
    }
  }
}
