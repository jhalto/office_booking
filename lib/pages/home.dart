import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:office_booking/custom_http/custom_http_request.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:office_booking/model_class/office_model_2.dart';
import 'package:office_booking/services/location_service.dart';
import 'package:office_booking/widget/custom_widgets.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getPosition();
    getHome();
    super.initState();
  }

  String? latitude;
  String? longitude;
  String? location;
  var isLoading = false;

  getPosition() async {
    setState(() {
      isLoading = true;
    });
    determinePosition().then(
          (value) async {
        final LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        );

        Position position = await Geolocator.getCurrentPosition(
            locationSettings: locationSettings);
        setState(() {
          latitude = position.latitude.toString();
          longitude = position.longitude.toString();
          location = position.accuracy.toString();
          isLoading = false;
        });
      },
    );
  }


  List<NearestOffice> officeList = [];

  getHome() async {
    try {
      String url = "${baseUrlDrop}home";
      var map = <String, dynamic>{};
      map['lat'] = "25.1972";
      map['lon'] = '55.2797';
      var response = await http.post(Uri.parse(url), body: map,
          headers: await CustomHttpRequest.getHeaderWithToken());
      var responseData = jsonDecode(response.body);
      if (responseData['status'] == true) {
        setState(() {
          officeList = List<NearestOffice>.from(
              responseData['data']['nearest offices'].map((office) =>
                  NearestOffice.fromJson(office)));
        });
      }
      print(response.statusCode);
      print(responseData);
    } catch (e) {
      print("something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: spinkit,
        child: Scaffold(
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
          body: officeList.isNotEmpty?
          SizedBox(

            height: MediaQuery.of(context).size.height*.20,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: officeList.length,
              itemBuilder: (context, index) {
                var office = officeList[index];
                 return Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Container(
                     width: 120,
                      child: Column(
                        children: [
                          Text("${office.name}",style: myStyle(15),),
                          Text("${office.location}"),
                          Expanded(child: Text("${office.shortDescription}"))
                        ],
                      ),
                    ),
                 );
              },
            ),
          ) :
          Text("no data"),
        )
    );
  }
}
