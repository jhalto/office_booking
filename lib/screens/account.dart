import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:office_booking/custom_http/custom_http_request.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:office_booking/providers/user_provider.dart';
import 'package:office_booking/widget/custom_widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).loadUserData();
    super.initState();
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController  = TextEditingController();
  TextEditingController _phoneController  = TextEditingController();
  String phone = '';


  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    if (user.name != null && _nameController.text.isEmpty) {
      _nameController.text = user.name!;
    }
    if (user.email != null && _emailController.text.isEmpty) {
      _emailController.text = user.email!;
    }

    return Scaffold(
      
        appBar: AppBar(
          title: Text(
            "Profile",
            style: myStyle(25, Colors.white),
          ),
          centerTitle: true,
        ),
        body: user.photo != null
            ? SingleChildScrollView(
              child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          "$imageUrlDrop${user.photo}",
                        ),
                      ),
                      title: Text(user.name!),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email!),
                          Text(user.phone!),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
              
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => Container(
                                         height: MediaQuery.of(context).size.height*.80,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        customTextField(
                                          hintText: "Please give name",
                                          controller: _nameController,
                                        ),
                                        SizedBox(height: 10,),
                                        IntlPhoneField(
                                          controller: _phoneController,
                                          initialCountryCode: 'BD',
                                          onChanged: (value) {
                                           setState(() {
                                             phone = value.completeNumber;
                                           });
                                          },

                                        ),
                                        SizedBox(height: 10,),
                                        customTextFromField(
                                            hintText: "Please insert email", controller: _emailController),
                                        customButton(text: "upadate", onPressed: (){
                                          changeUserData();
                                        })
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: tapContainer("Edit Profile",
                                Icon(CupertinoIcons.profile_circled)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          tapContainer('Save Cards', Icon(Icons.add_card_sharp)),
                          SizedBox(
                            height: 10,
                          ),
                          tapContainer(
                              'Favourites', Icon(CupertinoIcons.heart_fill)),
                          SizedBox(
                            height: 10,
                          ),
                          tapContainer('Save Cards', Icon(Icons.add_card_sharp)),
                          SizedBox(
                            height: 10,
                          ),
                          tapContainer('Change Password', Icon(Icons.edit)),
                          SizedBox(
                            height: 10,
                          ),
                          tapContainer('Terms & Conditions', Icon(Icons.rule)),
                          SizedBox(
                            height: 10,
                          ),
                          tapContainer('Website', Icon(Icons.web)),
                          SizedBox(
                            height: 10,
                          ),
                          tapContainer(
                              'Delete Account', Icon(Icons.add_card_sharp)),
                        ],
                      ),
                    )
                  ],
                ),
            )
            : spinkit);
  }
  changeUserData()async{
    try{
      String url = "${baseUrlDrop}profile";
      var map = <String,dynamic>{};
      map['name'] = _nameController.text.toString();
      map['email'] = _emailController.text.toString();
      map['phone'] = phone;

      var response = await http.post(Uri.parse(url),headers: await CustomHttpRequest.getHeaderWithToken(),body: map);
      var responseData = jsonDecode(response.body);
      print(responseData);
      if(responseData['status']== true){
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        // Update SharedPreferences
        sharedPreferences.setString('name', _nameController.text.toString());
        sharedPreferences.setString('email', _emailController.text.toString());
        sharedPreferences.setString('phone', phone);
        Navigator.pop(context);
        // Update UserProvider with the new data
        Provider.of<UserProvider>(context, listen: false).updateUserData(
          name: _nameController.text.toString(),
          email: _emailController.text.toString(),
          phone: phone,
        );

        print(sharedPreferences.getString('name'));
      }

      print(response.statusCode);

    }catch(e){
      print("went wrong $e");
    }
  }
}

Container tapContainer(String text, Icon icon) {
  return Container(
    decoration: BoxDecoration(
        border: Border.all(width: 2), borderRadius: BorderRadius.circular(15)),
    child: ListTile(
      leading: icon,
      title: Text(text),
      trailing: Icon(CupertinoIcons.forward),
    ),
  );
}
