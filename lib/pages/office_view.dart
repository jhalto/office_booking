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
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      setState(() {
        isLoading = true;
      });

      String url =
          "${baseUrlDrop}office/$pageIndex?lat=25.3899&lon=88.9916&date=2024-09-11";
      var response = await http.get(Uri.parse(url),
          headers: await CustomHttpRequest.getHeaderWithToken());
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          officeModel = OfficeModel.fromJson(responseData);
          setState(() {
            officeDataList.add(officeModel!.data!);
          });
        }
      } else if (response.statusCode == 401) {
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
      } else {
        print(response.statusCode);
        showToastMessage("${response.statusCode}");
      }
    } catch (e) {
      print("Something went wrong: $e");

      showToastMessage("Check your internet connection, then try again");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
  void initState() {
    super.initState();
    getOfficeData(1);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Office Details"),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  await logOut();
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : officeDataList.isEmpty
            ? Center(child: Text("No data available"))
            : ListView.builder(
          itemCount: officeDataList.length,
          itemBuilder: (context, index) {
            var office = officeDataList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      office!.name ?? 'No Name',
                      style: myStyle(20),
                    ),
                    SizedBox(height: 10),
                    Text(office.shortDescription, style: myStyle(15)),
                    SizedBox(height: 10),
                    Text(
                        "Location: ${office.location}",
                        style: myStyle(15)),
                    SizedBox(height: 10),
                    Text(
                        "Price per hour:  ${office.pricePerHr} ${office.currency}",
                        style: myStyle(15)),
                    SizedBox(height: 10),
                    Text(
                      "Capacity: ${office.capacity} person's",
                      style: myStyle(15),
                    ),
                    SizedBox(height: 10),
                    Text("Facilities: ", style: myStyle(18)),
                    ...office.facilities.map<Widget>((facility) {
                      return ListTile(
                        leading: Icon(Icons.check_circle),
                        title: Text(facility.name),
                      );
                    }).toList(),
                    SizedBox(height: 10),
                    Text("Photos: ", style: myStyle(18)),
                    Container(
                      height: 180,
                      child: GridView.builder(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: office.photos.length,
                        itemBuilder: (context, photoIndex) {
                          return Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(
                                    "${imageUrlDrop}${office.photos[photoIndex].url}"),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Menu: ", style: myStyle(18)),
                    Container(
                      height: 150,
                      child: ListView.builder(
                        itemCount: office.menus.length,
                        itemBuilder: (context, menuIndex) {
                          return ListTile(
                            leading: Icon(Icons.emoji_food_beverage),
                            title: Text(office.menus[menuIndex].name),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(office.longDescription),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
