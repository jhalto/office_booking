import 'package:flutter/material.dart';

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
      appBar: AppBar(title: Text("${widget.office['name']}"),),
    );
  }
}
