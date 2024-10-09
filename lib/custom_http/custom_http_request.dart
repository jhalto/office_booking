import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomHttpRequest{
        static Future<Map<String,String>> getHeaderWithToken()async{
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          var header = {
            "Accept" : "application/json",
            "Authorization": "bearer ${sharedPreferences.get('token')}"
          };
          return header;
        }


       // static Future<dynamic> getUserData()async{
       //    String? name;
       //    String? email;
       //    String? phone;
       //    String? photo;
       //    final TextEditingController _nameController = TextEditingController();
       //    final TextEditingController _emailController = TextEditingController();
       //    final TextEditingController _phoneController = TextEditingController();
       //    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
       //
       //      name = sharedPreferences.getString('name');
       //      email = sharedPreferences.getString('email');
       //      phone = sharedPreferences.getString('phone');
       //      photo = sharedPreferences.getString('photo');
       //      _nameController.text = name!;
       //      _emailController.text = email!;
       //      _phoneController.text = phone!;
       //
       //  }

}