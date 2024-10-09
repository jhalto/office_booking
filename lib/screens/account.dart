import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:office_booking/providers/user_provider.dart';
import 'package:office_booking/widget/custom_widgets.dart';
import 'package:provider/provider.dart';
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


  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    if (user.name != null && _nameController.text.isEmpty) {
      _nameController.text = user.name!;
    }
    if (user.email != null && _nameController.text.isEmpty) {
      _nameController.text = user.name!;
    }
    if (user.phone != null && _nameController.text.isEmpty) {
      _nameController.text = user.name!;
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
            ? Column(
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
                              context: context,
                              builder: (context) => Container(
                                child: Column(
                                  children: [
                                    customTextField(
                                      hintText: "Please give name",
                                      controller: _nameController,
                                    ),
                                    SizedBox(),
                                    customTextFromField(hintText: "Please insert email", controller: _emailController),
                                  ],
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
              )
            : spinkit);
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
