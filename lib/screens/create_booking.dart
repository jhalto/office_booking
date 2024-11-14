import 'package:flutter/material.dart';

import '../widget/custom_widgets.dart';

class CreateBooking extends StatefulWidget {
  CreateBooking({super.key,required this.office});
var office = <String, dynamic>{};

  @override
  State<CreateBooking> createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

    );
  }
}
