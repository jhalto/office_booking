import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:office_booking/screens/verification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  TextEditingController _confirmPasswordContoller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObsecure1 = true;
  bool isObsecure2 = true;
  String phone = '';
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      progressIndicator: spinkit,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 165,),
                        Padding(
                          padding: const EdgeInsets.only(left: 90,right: 90),
                          child: Container(
            
                            alignment: Alignment.center,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                color: Colors.white
                            ),
                            child: Center(
                              child: Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
            
                        SizedBox(height: 15),
                        Text("Welcome to Drops",style: myStyle(22,Colors.black,FontWeight.bold)),
                        SizedBox(height: 5,),
                        Text("Please enter your details below to get started",style: myStyle(15,Colors.black38,FontWeight.bold)),
                        SizedBox(height: 25,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Text("Name",style: myStyle(18,Colors.black,FontWeight.bold),),
                          SizedBox(height: 5,),
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
                            Text("Email",style: myStyle(18,Colors.black,FontWeight.bold),),
                            SizedBox(height: 5,),
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
                            Text("Phone",style: myStyle(18,Colors.black,FontWeight.bold),),
                            SizedBox(height: 5,),
                            IntlPhoneField(
                              onChanged: (value) {
                                setState(() {
                                  phone = value.completeNumber;
                                });

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
                          SizedBox(
                            height: 5,
                          ),
                            Text("Password",style: myStyle(18,Colors.black,FontWeight.bold),),
                            SizedBox(height: 5,),
                          TextFormField(
                            decoration: InputDecoration(
                                hintText: "Enter your password",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.5, color: Colors.black12),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2.5,
                                    color: Colors.blueAccent,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isObsecure1 = !isObsecure1;
                                      });
                                    },
                                    icon: isObsecure1 == true
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off))),
                            controller: _passwordContoller,
                            obscureText: isObsecure1,
                            validator: (value) {
                              // Reset error message
            
                              if (value == null || value.isEmpty) {
                                return 'Password is required.';
                              }
            
                              // Password length greater than 6
                              if (value.length < 6) {
                                return '• Password must be longer than 6 characters.\n';
                              }
                              // Contains at least one uppercase letter
                              if (!value.contains(RegExp(r'[A-Z]'))) {
                                return '• Uppercase letter is missing.\n';
                              }
                              // Contains at least one lowercase letter
                              if (!value.contains(RegExp(r'[a-z]'))) {
                                return '• Lowercase letter is missing.\n';
                              }
                              // Contains at least one digit
                              if (!value.contains(RegExp(r'[0-9]'))) {
                                return '• Digit is missing.\n';
                              }
                              // Contains at least one special character
                              if (!value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
                                return '• Special character is missing.\n';
                              }
            
                              // Return null if the password is valid, otherwise return the error message
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                            Text("Confirm Password",style: myStyle(18,Colors.black,FontWeight.bold),),
                            SizedBox(height: 5,),
                            TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Enter your password",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.5, color: Colors.black12),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.5,
                                      color: Colors.blueAccent,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isObsecure2 = !isObsecure2;
                                        });
                                      },
                                      icon: isObsecure2 == true
                                          ? Icon(Icons.visibility)
                                          : Icon(Icons.visibility_off))),
                              controller: _confirmPasswordContoller,
                              obscureText: isObsecure2,
                              validator: (value) {
                                // Reset error message
                                  if(_passwordContoller != _confirmPasswordContoller){
                                    return "Password doesn't match";
                                  }
                              }
                            ),
                            SizedBox(
                              height: 5,
                            ),
            
                        ],),
                        SizedBox(height: 15,),
                        customButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              getregister();
                              showToastMessage("succesfull");
                            }
                          },
                          text: "Sign Up",
                        ),


                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => VerificationPage(),));
                        }, child: Text("Verification page")),
                        SizedBox(height: 250,)
                      ],
                    ),
                  ),
                ),

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
      map['phone'] = phone.toString();
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
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('email', _emailContoller.text.toString());
        String otp = data['data']['otp']
            .toString(); // Assuming the OTP is returned in the response body

        // Call function to send the OTP via email
        await sendOtpEmail(_emailContoller.text, otp);
        String email = _emailContoller.text.toString();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationPage(
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
    String password = ''; // Sender's email password

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
