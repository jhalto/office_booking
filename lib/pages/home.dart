 import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:office_booking/custom_http/custom_http_request.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:office_booking/model_class/office_model_2.dart';
import 'package:office_booking/widget/custom_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart'as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    gettingData();


    super.initState();
  }

  String? name;
  String? latitude;
  String? longitude;
  String? location;
  var isLoading = false;

  // Initialize lists and selected capacity
  List<NearestOffice> officeList = [];
  List<NearestOffice> filteredOfficeList = [];
  dynamic selectedCapacity = "All";  // Changed to dynamic to handle both String and int

  // Updated capacity options with integer values
  final List<Map<String, dynamic>> capacityOptions = [
    {"label": "All", "value": "All"},
    {"label": "1 Person", "value": 1},
    {"label": "2 Person", "value": 2},
    {"label": "4 Person", "value": 4},
    {"label": "6 Person", "value": 6},
  ];

  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString('name');
    setState(() {});
  }

  getPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, unable to request.');
    }
  }
  gettingData(){
    getPosition();
    getUserData();
    getHome();

  }
  getPosition() async {
    setState(() {
      isLoading = true;
    });

    try {
      await getPermission();
      Position position = await Geolocator.getCurrentPosition();
      await getLocation(position.latitude, position.longitude);
      setState(() {
          latitude = position.latitude.toString();
          longitude = position.longitude.toString();

        });


      print("Position found: Lat - $latitude, Long - $longitude");

    } catch (e) {
      print("Location error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  getLocation(double latitude, double longitude) async {
    try {
      print("Retrieving address for coordinates: $latitude, $longitude");
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          location = "${place.name} - ${place.isoCountryCode}";
        });
        print("Location found: $location");
      } else {
        print("No placemarks found for the coordinates.");
      }
    } catch (e) {
      print("Error retrieving address: $e");
    }
  }

  void filterOfficeList() {
    setState(() {
      if (selectedCapacity == "All") {
        filteredOfficeList = officeList;
        print("Showing all offices: ${officeList.length}");
      } else {
        filteredOfficeList = officeList.where((office) {
          // Convert office.capacity to int for comparison
          int officeCapacity = int.tryParse(office.capacity.toString()) ?? 0;
          print("Comparing office ${office.name}: office.capacity=$officeCapacity with filter=$selectedCapacity");
          return officeCapacity == selectedCapacity;
        }).toList();

        print("Filtered offices for capacity $selectedCapacity: ${filteredOfficeList.length}");
      }
    });
  }

  getHome() async {
    setState(() {
      isLoading = true;
    });
    try {
      String url = "${baseUrlDrop}home";
      var map = <String, dynamic>{};
      map['lat'] = "25.197100";
      map['lon'] = "55.279700";
      print("${latitude}${longitude}");

      var response = await http.post(
          Uri.parse(url),
          body: map,
          headers: await CustomHttpRequest.getHeaderWithToken()
      );

      var responseData = jsonDecode(response.body);
      print("API Response: $responseData"); // Debug print

      if (responseData['status'] == true) {
        setState(() {
          officeList = List<NearestOffice>.from(
              responseData['data']['nearest offices']
                  .map((office) => NearestOffice.fromJson(office))
          );

          // Debug print to check parsed data
          print("Parsed offices:");
          for (var office in officeList) {
            print("Office: ${office.name}, Capacity: ${office.capacity}");
          }

          filterOfficeList();
          // Apply initial filter
        });
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching office data: $e");
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
                      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
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
        body: Column(
          children: [
            SizedBox(height: 20),
            // User greeting and location
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Hello"),
                      SizedBox(width: 5),
                      Text("${name ?? ''}", style: bodyBold()),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (location != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, size: 16),
                        SizedBox(width: 4),
                        Text("Current location: ${location}"),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Capacity filter
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: capacityOptions.length,
                itemBuilder: (context, index) {
                  final option = capacityOptions[index];
                  final isSelected = selectedCapacity == option["value"];

                  return Padding(

                    padding: EdgeInsets.only(left: 30),
                    child: Transform.scale(
                      scale: 1.1,
                      child: FilterChip(

                        shape: RoundedRectangleBorder(

                         side: BorderSide(
                             width: 2,
                             color: maya),
                          borderRadius: BorderRadius.circular(30)
                        ),
                        selected: isSelected,
                        label: Text(option["label"],style: TextStyle(color: isSelected == true?Colors.white:maya),),


                        onSelected: (bool selected) {
                          setState(() {
                            selectedCapacity = option["value"];
                            print("Selected capacity: $selectedCapacity"); // Debug print
                            filterOfficeList();
                          });
                        },

                        selectedColor: maya,
                       showCheckmark: false,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Office list
            Expanded(
              child: filteredOfficeList.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 48, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No offices available for ${selectedCapacity == "All" ? "any" : "$selectedCapacity person"} capacity",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredOfficeList.length,
                itemBuilder: (context, index) {
                  var office = filteredOfficeList[index];
                  print("Photo URL: ${office.photos[0].url}");
                  available()async{
                    try{
                      String urlA= "${baseUrlDrop}office-booked-schedule";
                      DateTime now = DateTime.now();
                      String formattedDate = DateFormat('yyyy-MM-dd').format(now);
                      var map = <String, dynamic>{};
                      map['office_id']= office.id.toString();
                      map['date']= formattedDate.toString();
                      var response = await http.post(Uri.parse(urlA),headers: await CustomHttpRequest.getHeaderWithToken());
                      var responseData = jsonDecode(response.body);
                      print(responseData);

                    }catch(e){

                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 20,top: 30,bottom: 60),
                    child: Container(
                      
                      height: 400,
                      width: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                          topLeft: Radius.circular(80),
                          topRight: Radius.circular(80)

                        ),
                          border: Border.all(
                          color: maya,
                          width: 2
                        ),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider("${imageUrlDrop}${office.photos[0].url}",))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            Row(

                              children: [
                                Text("${office.currency}",style: TextStyle(color: Colors.black,fontSize: 18),),
                                Text("${(double.tryParse(office.pricePerHr!) ?? 0).toStringAsFixed(0)}",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.black),),
                                SizedBox(width: 2,),
                                Text("/hr",style: TextStyle(color: Colors.black,fontSize: 18),),


                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(

                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Icon(Icons.location_on_outlined,color: Colors.black,),
                                  ),
                                  
                                  Expanded(child: Text("${office.location}",)),

                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(7),

                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      // _launchMapsUrl(office., )
                                    },
                                    child: Container(

                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white
                                      ),
                                      child: Row(
                                        children: [
                                          Text("${office.distance.toString().substring(0,5)}"),
                                          SizedBox(width: 4),
                                          Text("km"),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Container(

                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white
                                    ),
                                    child: Row(
                                      children: [
                                        Text("${office.capacity}"),
                                        SizedBox(width: 4),
                                        Text("Person"),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            office.isActive.toString()=="1"?Text("Availabe Now"):Text("Closed"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}