import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:office_booking/services/location_service.dart';
import 'package:office_booking/widget/custom_widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getPosition();
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
  getOffice()async{
    try{
      String url = "${baseUrlDrop}";
    }catch(e){

    }
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: spinkit,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Welcome Drops"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Text("Latitude is : $latitude"),
            Text("Latitude is : $longitude"),
            Text("accurracy is: $location"),
          ],
        ),
      ),
    );
  }
}
