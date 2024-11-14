import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:office_booking/custom_http/custom_http_request.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:office_booking/model_class/office_list_model.dart';
import 'package:office_booking/screens/create_booking.dart';
import '../widget/custom_widgets.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  void initState() {
    getPosition();
  }

  Map<String, dynamic>? officeInfo;

  getOfficeList() async {
    try {
      String url = "${baseUrlDrop}office";
      var map = <String, dynamic>{};
      map['lat'] = latitude.toString();
      map['lon'] = longitude.toString();
      var response = await http.post(
          Uri.parse(url), headers: await CustomHttpRequest.getHeaderWithToken(),
          body: map);
      var responseData = jsonDecode(response.body);
      print(responseData);
      if (responseData['status'] == true) {
        setState(() {
          officeInfo = Map<String, dynamic>.from(responseData);
          print(officeInfo);
        });
      }
    } catch (e) {

    }
  }

  var isLoading = false;
  String? latitude;
  String? longitude;

  getPosition() async {
    setState(() {
      isLoading = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
      });


      print("Position found: Lat - $latitude, Long - $longitude");
      getOfficeList();
    } catch (e) {
      print("Location error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return officeInfo != null ? Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.white,
              toolbarHeight: 70,
              elevation: 0,
              title: Container(
                width: 117,
                child: Column(
                  children: [
                    Text(
                      "DROPS",
                      style: TextStyle(
                          fontSize: 36, fontWeight: FontWeight.bold),
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
        body: Stack(
          children: [
            Container(
              color: Colors.blue.shade100,
            ),
            Column(
              children: [
                Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: MaterialButton(
                            height: 55,
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.location_on_outlined,
                                  color: Colors.white,),
                                SizedBox(width: 5,),
                                Text("Location",
                                  style: TextStyle(color: Colors.white),),
                                SizedBox(width: 5,),
                                Icon(Icons.arrow_circle_down,
                                  color: Colors.white,),
                              ],
                            ),
                            color: maya,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        )
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: MaterialButton(
                            height: 55,
                            color: maya,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.userPlus,
                                  color: Colors.white,),
                                SizedBox(width: 8,),
                                Text("Capacity",
                                  style: TextStyle(color: Colors.white),),
                                SizedBox(width: 2,),
                                Icon(CupertinoIcons.minus, size: 10,
                                  color: Colors.white,),
                                SizedBox(width: 2,),
                                Text(
                                  "1", style: TextStyle(color: Colors.white),),
                                SizedBox(width: 2,),
                                Icon(CupertinoIcons.add, size: 10,
                                  color: Colors.white,)
                              ],
                            ),),
                        ))
                      ],
                    )),
                Spacer(),
                Padding(

                  padding: EdgeInsets.only(
                    left: 20,
                    bottom: 50,
                  ),
                  child: Container(

                      decoration: BoxDecoration(
                        color: Colors.black12.withOpacity(.5),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            topLeft: Radius.circular(30)
                        ),
                      ),
                      height: 200,
                      width: double.infinity,

                      child: Container(

                          width: 280,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: officeInfo!['data']['data'].length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, left: 20),
                                    child: Container(
                                      height: 110,
                                      width: 280,

                                      decoration: BoxDecoration(
                                          color: caya,
                                          borderRadius: BorderRadius.circular(
                                              17)
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(flex: 1, child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20, bottom: 20, left: 15),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(15),
                                                  image: DecorationImage(

                                                      image: AssetImage(
                                                        "lib/asset/image/office_1.jpg",),
                                                      fit: BoxFit.fill)
                                              ),
                                            ),
                                          )),
                                          Expanded(flex: 2, child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  "${officeInfo!['data']['data'][index]['location']}",
                                                  style: whiteStyle(),),
                                                Text(
                                                  "${officeInfo!['data']['data'][index]['city']}",
                                                  style: whiteStyle(),),
                                                SizedBox(height: 5,),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 5,
                                                          right: 5,
                                                          top: 3,
                                                          bottom: 3),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(30),
                                                          color: Colors.white
                                                      ),
                                                      child: Text(
                                                          "${officeInfo!['data']['data'][index]['capacity']} PERSON"),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 5,
                                                          right: 5,
                                                          top: 3,
                                                          bottom: 3),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(30),
                                                          color: Colors.white
                                                      ),
                                                      child: Text(
                                                          "${double.parse(
                                                              officeInfo!['data']['data'][index]['distance']
                                                                  .toString())
                                                              .toStringAsFixed(
                                                              2)} km"),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8,
                                        left: 20.0),
                                    child: Row(
                                      children: [
                                        MaterialButton(
                                          height: 40,
                                          minWidth: 110,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(30)
                                          ),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateBooking(
                                                        office: officeInfo!['data']['data'][index],
                                                      ),));
                                          },
                                          color: maya,
                                          child: Text(
                                            "Book Now", style: whiteStyle(),),),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("starting at",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10),),
                                              Text("AED 100/hr",
                                                style: whiteStyle(),),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          )
                      )
                  ),
                ),

              ],
            )
          ],
        )
    ) : spinkit
    ;
  }

}
