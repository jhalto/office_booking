import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:office_booking/screens/bottom_navigation_bar.dart';
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

  String loginBy = 'email'; // Default value
  bool isObsecure = false;
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
          body: Container(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Login Page"),
                      SizedBox(height: 20),
                      DropdownButton<String>(
                        value: loginBy,
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
                            loginBy = value!;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.black12),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 3,
                              color: Colors.blueAccent,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: loginBy == 'email'
                              ? "Enter your email"
                              : "Enter your phone number",

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
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Enter your password",
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 3, color: Colors.black12),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: Colors.blueAccent,
                              ),
                              borderRadius: BorderRadius.circular(15),
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
                      MaterialButton(
                        onPressed: () {
                          if(_formKey.currentState!.validate()){
                            getLogin();

                          }

                        },
                        child: Text("Login"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ));
                        },
                        child: RichText(
                          text: TextSpan(
                              text: "Don't have an account?",
                              style: myStyle(18, Colors.black),
                              children: [
                                TextSpan(
                                    text: "Sign up.",
                                    style:
                                        myStyle(20, Colors.red, FontWeight.bold)),
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
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

    if (token != null && expiryTime != null) {
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
        print("Token has expired and is deleted.");
      }
    }
  }
  var isloading = false;
  

  getLogin() async {
    try {
      setState(() {
        isloading = true;
      });
      String url = "${baseUrlDrop}login";

      var _map = <String, dynamic>{};
      _map['login_by'] = loginBy; // Send the selected login option
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
        showToastMessage("login Succesfull");
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        String token = data['data']['token'];
        int tokenExpiresIn = data['data']['token_expires_in']; // Convert to milliseconds

        sharedPreferences.setString('token', token);
        // Store token expiration time (30 days from now)
        int expiryTime = DateTime.now().add(Duration(seconds: tokenExpiresIn)).millisecondsSinceEpoch;
        await sharedPreferences.setInt('token_expiry', expiryTime);

        sharedPreferences.setString('token', token);

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
