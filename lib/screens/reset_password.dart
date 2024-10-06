import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:office_booking/screens/login_page.dart';
import 'package:office_booking/screens/verification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../key/api_key.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool _isEmailSelected = true;
  TextEditingController _otpController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100,),bottomRight: Radius.circular(100)),
                  image: DecorationImage(
                    image: AssetImage('lib/asset/image/office_1.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  // Image at the top
                  SizedBox(
                    height: 185,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 70,right: 70),
                          child: Container(

                            alignment: Alignment.center,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Colors.white
                            ),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                       Text("Please Enter Your Otp"),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _otpController,
                          decoration: InputDecoration(
                            hintText: 'Otp',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Please Enter Your Password"),
                        TextFormField(

                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: 'Email ID',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        ElevatedButton(
                          child: Text('Submit'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {

                          resetPassword();
                          },
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            child: Text('Back to Login'),
                            onPressed: () {
                              // Handle back to login action
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  verifyWith(){
    if(_isEmailSelected == true){
      return "email".toString();
    }else{
      return "phone".toString();
    }
  }
  resetPassword()async{
    String url = "${baseUrlDrop}reset-password";
    String password = _passwordController.text.toString();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var map = <String,dynamic>{};
    map['otp_by'] = 'email';
    map['email'] = sharedPreferences.getString('forgot_email');
    map['otp'] = _otpController.text.toString();
    map['password'] = password;
    var response = await http.post(Uri.parse(url),body: map,);
    var data = jsonDecode(response.body);
    print(data);
    print(response.statusCode);
    if(data['status']==true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
    }

  }

}