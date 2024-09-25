import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:office_booking/screens/bottom_navigation_bar.dart';
import 'package:office_booking/screens/register_page.dart';
import 'package:office_booking/widget/custom_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String loginBy = 'email'; // Default value

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
                        hintText: loginBy == 'email'
                            ? "Enter your email"
                            : "Enter your phone number",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        getLogin();

                      },
                      child: Text("Login"),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage(),));
                      },
                      child: RichText(text: TextSpan(text: "Dont have an account?",style: myStyle(18,Colors.black)
                      ,children: [
                        TextSpan(text: "Sign up.",style: myStyle(20, Colors.red,FontWeight.bold)),
                          ] ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
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
      if(response.statusCode==200){
        showToastMessage("Login Successful");
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavBar(),));
      }
    } catch (e) {
      setState(() {
        isloading = false;

      });
      print("Error: $e");
    }
  }
}
