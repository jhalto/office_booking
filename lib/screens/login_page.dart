import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:office_booking/screens/bottom_navigation_bar.dart';
import 'package:office_booking/screens/password_reset_screen.dart';
import 'package:office_booking/screens/register_page.dart';
import 'package:office_booking/widget/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isEmailSelected = true; // Default value
  bool isObsecure = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    isLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isloading,
        progressIndicator: spinkit,
        opacity: .5,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            width: double.infinity,
            child: Form(
              key: _formKey,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

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
                                'Log In',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Align(
                            alignment: Alignment.center,
                            child: Text("Welcome to Drops",style: myStyle(22,Colors.black,FontWeight.bold),)),
                        SizedBox(height: 15),
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
                        SizedBox(height: 10),
                        _isEmailSelected == true?
                        Text("Email ID",style: myStyle(15,Colors.black,FontWeight.bold),)
                        :Text("Phone",style: myStyle(15,Colors.black,FontWeight.bold),),
                        SizedBox(height: 5,),
                        _isEmailSelected== true?TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2.5, color: Colors.black12),
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
                          hintText:
                              "Enter your email"

                          ),
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
                        SizedBox(height: 10),
                        Text("Password",style: myStyle(15,Colors.black,FontWeight.bold),),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Enter your password",
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
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isObsecure = !isObsecure;
                                    });
                                  },
                                  icon: isObsecure == true
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off))),
                          controller: passwordController,
                          obscureText: isObsecure,
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
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(onPressed: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetScreen(),));
                          }, child: Text("Forgot Password",style: myStyle(15,Colors.black,FontWeight.bold),)),
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(
                          child: Text('Log In',style: myStyle(18,Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            if(_formKey.currentState!.validate()){
                              getLogin();

                            }

                          },
                        ),
                        SizedBox(height: 15,),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegisterPage(),
                                  ));
                            },

                            child: RichText(
                              text: TextSpan(
                                  text: "Don't have an account yet?",
                                  style: myStyle(17, Colors.black38),
                                  children: [
                                    TextSpan(
                                        text: " Sign up",
                                        style:
                                            myStyle(17, Colors.black, FontWeight.bold)),
                                  ]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
        ),

    );
  }

  isLogin()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('token');
    var expiryTime = sharedPreferences.getInt('token_expiry');
    var password = sharedPreferences.getString('password');
    var email = sharedPreferences.getString('email');


    if (token != null && expiryTime != null && password != null && email != null) {
      // Check if the token has expired
      if (DateTime.now().millisecondsSinceEpoch < expiryTime) {
        // Token is still valid
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => BottomNavBar()),
              (route) => false,
        );
      } else {
        // Token has expired, remove it
        await sharedPreferences.remove('token');
        await sharedPreferences.remove('token_expiry');
        await sharedPreferences.remove('password');
        await sharedPreferences.remove('email');
        print("Token has expired and is deleted.");

      }

    }
  }
  var isloading = false;

  verifyWith(){
    if(
    _isEmailSelected == true){
      return "email".toString();
    }else{
      return "phone".toString();
    }
  }
  getLogin() async {
    try {
      setState(() {
        isloading = true;
      });
      String url = "${baseUrlDrop}login";

      var _map = <String, dynamic>{};
      _map['login_by'] = verifyWith(); // Send the selected login option
      _map['email'] = emailController.text.toString();
      _map['password'] = passwordController.text.toString();
      var response = await http.post(Uri.parse(url), body: _map);
      var data = jsonDecode(response.body);
      print("Request Payload: ${jsonEncode(_map)}");
      setState(() {
        isloading = false;
      });

      print("Status Code: ${response.statusCode}");
      print("Response: $data");
      if (data['status']==true) {

        showToastMessage("login Successful");
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String token = data['data']['token'];
        String email = data['data']['user']['email'];
        String name = data['data']['user']['name'];
        String phone = data['data']['user']['phone'];
        String photo = data['data']['user']['photo'];
        int tokenExpiresIn = data['data']['token_expires_in']; // Convert to milliseconds
        sharedPreferences.setString('password', passwordController.text.toString());

        sharedPreferences.setString('token', token);
        sharedPreferences.setString('email', email);
        sharedPreferences.setString('name', name);
        sharedPreferences.setString('phone', phone);
        sharedPreferences.setString('photo', photo);

        // Store token expiration time (30 days from now)
        int expiryTime = DateTime.now().add(Duration(seconds: tokenExpiresIn)).millisecondsSinceEpoch;
        await sharedPreferences.setInt('token_expiry', expiryTime);

        sharedPreferences.setString('token', token);
        print("password is : ${sharedPreferences.getString('password')}");
        print("user token is :${sharedPreferences.getString('token')}");
        print("expiry_time is; ${sharedPreferences.getInt('token_expiry')}");

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavBar(),), (route) => route.isCurrent,);
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print("Error: $e");
    }
  }
}
