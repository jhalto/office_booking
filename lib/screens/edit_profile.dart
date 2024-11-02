import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:office_booking/custom_http/custom_http_request.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:http/http.dart'as http;
import 'package:office_booking/widget/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key, required this.name, required this.email, required this.phoneEdit, required this.photo});
  String? name;
  String? email;
  String? phoneEdit;
  String? photo;
  var loading = true;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController? _nameController;
  TextEditingController? _emailController;
  TextEditingController? _phoneController;
  String? photo;
  File? picked;


  String phone="";
  pickImageFromCamera()async{
    ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    if(pickedImage!= null){
      setState(() {
        picked = File(pickedImage.path);
      });
    }


  }
  @override
  void initState() {
    String phoneFinal = widget.phoneEdit.toString();
    String subString = phoneFinal.substring(4);
    _nameController = TextEditingController(text: widget.name);
    _emailController= TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: subString);
    photo = widget.photo;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      progressIndicator: spinkit,
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(

              children: [
                Center(
                  child: Container(
                    height: 200,
                    child: picked!= null?Image.file(picked!):widget.photo!.startsWith("/data")?Image.file(File(widget.photo!)):Image.network("${imageUrlDrop}${widget.photo}"),
                  ),
                ),
                IconButton(onPressed: (){
                  pickImageFromCamera();
                }, icon: Icon(Icons.photo)),
                SizedBox(
                  height: 10,
                ),
                _customEditTextField(
                  _nameController!,
                ),
                SizedBox(height: 10,),
                _customEditTextField(
                  _emailController!,
                ),
                SizedBox(height: 10,),
                IntlPhoneField(
                  controller: _phoneController,
                  initialCountryCode: "BD",
                  onChanged: (value) {
                    setState(() {
                      phone = value.completeNumber;
                      print(phone);
                    });
                  },
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 3,
                        )
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          width: 3,
                        )
                    ),
                  ),
                ),
                MaterialButton(onPressed: (){
                  updateData();
                },
                  child: Text("Update"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  _customEditTextField(TextEditingController controller){
    return TextField(
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 3,
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              width: 3,
            )
        ),
      ),
      controller: controller,
    );
  }
  var isloading = false;
  updateData()async{
    try{

      setState(() {
       isloading = true;
      });
      var url = "${baseUrlDrop}profile";
      if(phone.isEmpty){
        setState(() {
          phone = widget.phoneEdit.toString();
        });

      }

      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers.addAll(await CustomHttpRequest.getHeaderWithToken());
      request.fields['name']= _nameController!.text.toString();
      request.fields['email']= _emailController!.text.toString();
      request.fields['phone']= phone;
      if(picked!= null){
        var img = await http.MultipartFile.fromPath("photo", picked!.path);
        request.files.add(img);
      }else{

      }
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      var data = jsonDecode(responseString);
      print("our response is $data");
      if(data['status']==true){
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

          sharedPreferences.setString('name', _nameController!.text.toString());
          sharedPreferences.setString('email', _emailController!.text.toString());
          sharedPreferences.setString('phone', phone);
          if (picked != null) {
            sharedPreferences.setString('photo', picked!.path);
          } else {
            sharedPreferences.setString('photo', widget.photo!);
          }



        Navigator.pop(context,true);

      }
      setState(() {
        isloading = false;
      });
    }catch(e){
      print("something went wrong $e");
    }
  }

}