import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:http/http.dart'as http;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customTextFromField(
              hintText: "Enter your name", controller: _nameContoller,),
            SizedBox(height: 5,),
            customTextFromField(
                hintText: "Enter your email", controller: _emailContoller),
            SizedBox(height: 5,),
            customTextFromField(
                hintText: "Enter your phone", controller: _phoneContoller),
            SizedBox(height: 5,),
            customTextFromField(
                hintText: "Enter password", controller: _passwordContoller),
            SizedBox(height: 5,),
            MaterialButton(
              onPressed: () {
                getregister();
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
  getregister()async{
    try{
      String url = "${baseUrlDrop}registration";
      var map = <String, dynamic>{};
      map["name"] = _nameContoller.text.toString();
      map['email'] = _emailContoller.text.toString();
      map['phone'] = _phoneContoller.text.toString();
      map['password'] = _passwordContoller.text.toString();

      var response = await http.post(Uri.parse(url),body: map);
      var data = jsonDecode(response.body);
      print("Request Payload: ${jsonEncode(map)}");
      print(response.statusCode);
      print(data);

    }catch(e){

    }

  }
}
