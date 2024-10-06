
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:office_booking/custom_http/custom_http_request.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:office_booking/model_class/office_model.dart';
import 'package:office_booking/screens/login_page.dart';
import 'package:office_booking/widget/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../key/api_key.dart';

class OfficeView extends StatefulWidget {
  const OfficeView({super.key});

  @override
  State<OfficeView> createState() => _OfficeViewState();
}

class _OfficeViewState extends State<OfficeView> {
  OfficeModel? officeModel;
  List<Data?> officeDataList = [];
  bool isLoading = false;

  Future<void> getOfficeData(int pageIndex) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        isLoading = true;
      });

      String url = "${baseUrlDrop}office/$pageIndex?lat=25.3899&lon=88.9916&date=2024-09-11";
      var response = await http.get(Uri.parse(url), headers: await CustomHttpRequest.getHeaderWithToken());
      if(response.statusCode == 200){
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == true) {



          officeModel = OfficeModel.fromJson(responseData);
          setState(() {
            officeDataList.add(officeModel!.data);
          });
          setState(() {
            isLoading = false;
          });

      }
      }else if(response.statusCode == 401){
        await sharedPreferences.remove('email');
        await sharedPreferences.remove('password');
        await sharedPreferences.remove('token');
        await sharedPreferences.remove('token_expiry');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false,);
      }
      else{
        print(response.statusCode);
        showToastMessage("${response.statusCode}");
      }
    } catch (e) {
      print("Something went wrong: $e");

      showToastMessage("check your internet connection, then try again");



    }
  }
  logOut()async{
    try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      String url = "${baseUrlDrop}logout";
      var map = <String,dynamic>{};
      map['email'] = sharedPreferences.getString('email');
      map['password'] = sharedPreferences.getString('password');

      var response = await http.post(Uri.parse(url),body: map,headers: await CustomHttpRequest.getHeaderWithToken());
      var responseData = jsonDecode(response.body);

      if(responseData['status']==true){

        await sharedPreferences.remove('email');
        await sharedPreferences.remove('password');
        await sharedPreferences.remove('token');
        await sharedPreferences.remove('token_expiry');
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage(),), (route) => false,);

      }

    }catch(e){
      print("something went wrong $e");
    }
  }

  @override
  void initState(){
    super.initState();

    getOfficeData(1); // Fetch initial data
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Office Details"),centerTitle: true,
        actions: [
          IconButton(onPressed: ()async{
            await logOut();
          }, icon: Icon(Icons.logout))
        ],
        ),
        body: officeDataList.isEmpty
            ? Center(child: spinkit)  // Show loading spinner if data is still loading
            : PageView.builder(
          itemCount: officeDataList.length+1,  // Adding one more for loading more data
          controller: PageController(initialPage: 0),
          onPageChanged: (int pageIndex) {
            if (pageIndex == officeDataList.length) {
              // Load more data when reaching the end of the current list
              getOfficeData(pageIndex + 1);
            }
          },
          itemBuilder: (context, index) {
            if (index < officeDataList.length) {
              // Display the loaded office data
              final officeData = officeDataList[index];
              if (officeData != null) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(officeData.name ?? 'No Name',style: myStyle(20),),
                        SizedBox(height: 10,),
                        Text(officeData.shortDescription,style: myStyle(15)),
                        SizedBox(height: 10,),
                        Text("Location: ${officeData.location}",style: myStyle(15)),
                        SizedBox(height: 10,),
                        Text("Price per hour:  ${officeData.pricePerHr} ${officeData.currency}",style: myStyle(15)),
                        SizedBox(height: 10,),
                        Text("Capacity: ${officeData.capacity} person's",style: myStyle(15),),
                        SizedBox(height: 10,),
                        Text("Facilities: ",style: myStyle(18),),
                        ...officeData.facilities.map<Widget>((e) {
                          return ListTile(
                            leading: Icon(Icons.check_circle),
                            title: Text(e.name),
                          );
                        },),
                        ...officeData.photos.map<Widget>((e) {
                          print(e);
                          return Container(
                            height: 150,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: NetworkImage("${imageUrlDrop+e.url}")),
                            ),
                          );
                        },),
                        Text("Menu:",style: myStyle(18)),
                        ...officeData.menus.map<Widget>((e) {
                          return ListTile(
                            leading: Image.network(
                              imageUrlDrop+e.image,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.fastfood);
                              },
                            ),
                            title: Text(e.name),
                          );
                        },),
                        Text("${officeData.longDescription}"),

                      ],
                    ),
                  ),
                );
              } else {
                return Center(child: Text("No data available"));
              }
            } else {
              // Show a loading spinner when more data is being fetched
              return Center(child: isLoading ? spinkit : Text("No more data"));
            }
          },
        ),
      ),
    );
  }
}


