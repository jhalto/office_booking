import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:office_booking/custom_http/custom_http_request.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:office_booking/model_class/office_model_2.dart';
import 'package:office_booking/widget/custom_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    getUserData();
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

  getPosition() async {
    setState(() {
      isLoading = true;
    });

    try {
      await getPermission();
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      latitude = position.latitude.toString();
      longitude = position.longitude.toString();

      print("Position found: Lat - $latitude, Long - $longitude");
      await getLocation(position.latitude, position.longitude);
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
          location = "${place.locality}, ${place.administrativeArea}, ${place.country}";
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
    try {
      String url = "${baseUrlDrop}home";
      var map = <String, dynamic>{};
      map['lat'] = latitude ?? "25.1972";
      map['lon'] = longitude ?? '55.2797';

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
                        Text(location!, style: small()),
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
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(option["label"]),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedCapacity = option["value"];
                          print("Selected capacity: $selectedCapacity"); // Debug print
                          filterOfficeList();
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.blue[100],
                      checkmarkColor: Colors.blue,
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
                            image: NetworkImage("${imageUrlDrop}${office.photos[0].url}",))
                      ),
                      child: Column(
                        children: [
                          Text("${office.name}")
                        ],
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