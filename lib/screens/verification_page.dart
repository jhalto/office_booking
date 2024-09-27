import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:office_booking/screens/login_page.dart';
import 'package:office_booking/widget/custom_widgets.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../key/api_key.dart';

class VerificationPage extends StatefulWidget {

  VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  TextEditingController _otpController = TextEditingController();
  @override

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
                TextButton(onPressed: (){
                       resendOtp();
                }, child: Text("Resend Otp")),
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
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String? email = sharedPreferences.getString('email');
      String url = "${baseUrlDrop}verify-otp";
      var map = <String, dynamic>{};
      map['otp_by'] = otpBy;

      map['email'] = email;
      map['otp'] = _otpController.text.toString();
      print(email);
      var response = await http.post(Uri.parse(url),body: map);
      var data = jsonDecode(response.body);
      print(response.statusCode);
      print(data);


      if(data['status']==  true){
        bool isRemoved = await sharedPreferences.remove('email');
        if(isRemoved){
          print("remove successfull");
        }else{
          print("remove unsuccessfull");
        }
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => route.isFirst,).then((value) {
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
  resendOtp()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? email = sharedPreferences.getString('email');
    String url = "${baseUrlDrop}send-otp";
    var map = <String,dynamic>{};
    map['otp_by'] = otpBy;
    map['email'] = email;
    var response = await http.post(Uri.parse(url),body: map);
    var data = jsonDecode(response.body);
    print(data);
    print(response.statusCode);
    if(data['status']==true){
      String otp = data['data']['otp'].toString();
      sendOtpEmail(email!, otp);
    }

  }
  Future<void> sendOtpEmail(String recipientEmail, String otp) async {
    // Define your SMTP settings (use your credentials)
    String username = 'zobayerarmannadim@gmail.com'; // Sender's email
    String password = 'ztsx axap lofu tbwv'; // Sender's email password

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Office booking') // From email and name
      ..recipients.add(recipientEmail) // Recipient's email
      ..subject = 'Your OTP Code'
      ..text = 'Your OTP code is: $otp';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error occurred while sending email: $e');
    }
  }
}
