import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:office_booking/screens/reset_password.dart';
import 'package:office_booking/screens/verification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import '../key/api_key.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  bool _isEmailSelected = true;
  TextEditingController _emailController = TextEditingController();

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
                  borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(300,130),bottomRight: Radius.elliptical(300,130)),
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
                              'Forgot Password',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text('Verify with'),
                            Radio(
                              value: true,
                              groupValue: _isEmailSelected,
                              onChanged: (value) {
                                setState(() {
                                  _isEmailSelected = value!;
                                });
                              },
                            ),
                            Text('Email'),
                            Radio(
                              value: false,
                              groupValue: _isEmailSelected,
                              onChanged: (value) {
                                setState(() {
                                  _isEmailSelected = value!;
                                });
                              },
                            ),
                            Text('Phone'),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Please enter your registered Email Address below to verify your account',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        _isEmailSelected == true?TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email ID',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ):IntlPhoneField(
                          onChanged: (value) {
                            var phone = value.completeNumber;
                            print(phone);
                          },
                          initialCountryCode: 'BD',
                          decoration: InputDecoration(
                            hintText: "Enter Your Phone",
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(width: 3, color: Colors.black12),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.blueAccent,
                              ),
                              borderRadius: BorderRadius.circular(25),
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
                            passwordOtp();

                          },
                        ),
                        SizedBox(height: 20),

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
  passwordOtp()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String url = "${baseUrlDrop}send-otp";
    String email = _emailController.text.toString();
    sharedPreferences.setString('forgot_email', email);
    var map = <String,dynamic>{};
    map['otp_by'] = verifyWith();
    map['email'] = email;
    var response = await http.post(Uri.parse(url),body: map);
    var data = jsonDecode(response.body);
    print(data);
    print(response.statusCode);
    if(data['status']==true){
      String otp = data['data']['otp'].toString();
      sendOtpEmail(email!, otp);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResetPassword(),));
    }

  }
  Future<void> sendOtpEmail(String recipientEmail, String otp) async {
    // Define your SMTP settings (use your credentials)
    String username = 'zobayerarmannadim@gmail.com'; // Sender's email
    String password = appPassword; // Sender's email password

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