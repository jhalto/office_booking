import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:office_booking/custom_http/custom_http_request.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:office_booking/providers/user_provider.dart';
import 'package:office_booking/screens/edit_profile.dart';
import 'package:office_booking/widget/custom_widgets.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  void initState() {
    super.initState();
    getUserData();
  }

  String? phoneEdit;
  String? name;
  String? email;
  String? phone;
  String? photo;
  String phoneSubstring = '';

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    name = sharedPreferences.getString('name');
    email = sharedPreferences.getString('email');
    phone = sharedPreferences.getString('phone');
    photo = sharedPreferences.getString('photo');
    phoneEdit = phone!;
    phoneSubstring = phoneEdit!.substring(4);
    print(photo);
    setState(() {});
  }

  logOut() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String url = "${baseUrlDrop}logout";
      var map = <String, dynamic>{};
      map['email'] = sharedPreferences.getString('email');
      map['password'] = sharedPreferences.getString('password');

      var response = await http.post(Uri.parse(url),
          body: map, headers: await CustomHttpRequest.getHeaderWithToken());
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == true) {
        await sharedPreferences.remove('email');
        await sharedPreferences.remove('password');
        await sharedPreferences.remove('token');
        await sharedPreferences.remove('token_expiry');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      print("Something went wrong: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), // Shadow color
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Position the shadow below the AppBar
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 70,
              elevation: 0,
              // Set elevation to 0 to prevent AppBar shadow
              title: Container(
                width: 117,
                child: Column(
                  children: [
                    Text(
                      "DROPS",
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("by Cloud Spaces", style: small()),
                    ),
                  ],
                ),
              ),
              leading: Icon(Icons.notifications_none),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(Icons.messenger_outline),
                ),
              ],
              centerTitle: true,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: phone != null
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: photo!.startsWith("/data")
                            ? FileImage(File(photo!))
                            : NetworkImage("${imageUrlDrop}${photo}"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Hello"),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${name}",
                          style: bodyBold(),
                        ),
                        Text(
                          "!",
                          style: bodyBold(),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                      name: name,
                                      email: email,
                                      phoneEdit: phoneEdit,
                                      photo: photo,
                                    ),
                                  ));
                              if (result == true) {
                                await getUserData();
                              }
                            },
                            child: tapContainer("Edit Profile",
                                Icon(CupertinoIcons.profile_circled)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          tapContainer('Preferred Drops',
                              Icon(Icons.favorite_border_outlined)),
                          SizedBox(
                            height: 20,
                          ),
                          tapContainer('Terms & Conditions',
                              Icon(Icons.note_alt_outlined)),
                          SizedBox(
                            height: 50,
                          ),
                          GestureDetector(
                            onTap: () {
                              logOut();
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(width: 2, color: maya)),
                              child: Center(
                                child: Text(
                                  "Logout",
                                  style: TextStyle(color: maya),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : spinkit,
        ));
  }
}

Container tapContainer(String text, Icon icon) {
  return Container(
    height: 60,
    decoration:
        BoxDecoration(color: maya, borderRadius: BorderRadius.circular(30)),
    child: Center(
      child: ListTile(
        leading: icon,
        title: Text(text),
        trailing: Icon(CupertinoIcons.arrow_right_circle),
      ),
    ),
  );
}
