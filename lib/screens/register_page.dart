import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:office_booking/screens/verification_page.dart';
import '../widget/custom_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameContoller = TextEditingController();
  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _phoneContoller = TextEditingController();
  TextEditingController _passwordContoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      progressIndicator: spinkit,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Register"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                customTextFromField(
                  hintText: "Enter your name",
                  controller: _nameContoller,
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return "name can't be empty";
                    }
                    if (value.length < 3) {
                      return "must at least 3 letter";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                customTextFromField(
                  hintText: "Enter your email",
                  controller: _emailContoller,
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return "email can't be null";
                    }
                    if (value.length < 5) {
                      return "Invalid email";
                    }
                    if (!value.contains("@")) {
                      return "Invalid email";
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                customTextFromField(
                    hintText: "Enter your phone", controller: _phoneContoller),
                SizedBox(
                  height: 5,
                ),
                customTextFromField(
                  hintText: "Enter password",
                  controller: _passwordContoller,
                  validator: (value) {
                    if (value!.isEmpty || value == null) {
                      return "password can't be null";
                    }
                    if (value.length < 6) {
                      return "Invalid password";
                    }
                    if (!value.contains("")) {
                      return "Invalid email";
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                MaterialButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      getregister();
                      showToastMessage("succesfull");
                    }
                  },
                  child: Text("Submit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  var isloading = false;

  getregister() async {
    try {
      setState(() {
        isloading = true;
      });
      print("Email before sending: ${_emailContoller.text.toString()}");
      String url = "${baseUrlDrop}registration";
      var map = <String, dynamic>{};
      map["name"] = _nameContoller.text.toString();
      map['email'] = _emailContoller.text.toString();
      map['phone'] = _phoneContoller.text.toString();
      map['password'] = _passwordContoller.text.toString();

      var response = await http.post(Uri.parse(url), body: map);
      var data = jsonDecode(response.body);

      print("Request Payload: ${jsonEncode(map)}");
      print(response.statusCode);
      print(data);
      setState(() {
        isloading = false;
      });
      if (response.statusCode == 200) {
        String otp = data['data']['otp']
            .toString(); // Assuming the OTP is returned in the response body

        // Call function to send the OTP via email
        await sendOtpEmail(_emailContoller.text, otp);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationPage(
                email: _emailContoller.text.toString(),
              ),
            )).then(
          (value) {
            setState(() {
              _nameContoller.clear();
              _emailContoller.clear();
              _phoneContoller.clear();
              _passwordContoller.clear();
            });
          },
        );
      }

      setState(() {
        isloading = false;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> sendOtpEmail(String recipientEmail, String otp) async {
    // Define your SMTP settings (use your credentials)
    String username = 'zobayerarmannadim@gmail.com'; // Sender's email
    String password = 'insert your app password here'; // Sender's email password

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Your App Name') // From email and name
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
