import 'package:flutter/cupertino.dart';
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
     body: SingleChildScrollView(
       child: Column(

         children: [
           Container(
             height: 400,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.vertical(
                 bottom: Radius.circular(40)
               ),
               image: DecorationImage(
                   fit: BoxFit.fill,
                   image: AssetImage("lib/asset/image/office_1.jpg")
               )
             ),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Padding(
                   padding: const EdgeInsets.only(top: 20,left: 20),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                         children: [
                           Container(
                             padding: EdgeInsetsDirectional.symmetric(horizontal: 5),
                               decoration: BoxDecoration(

                                   borderRadius: BorderRadius.circular(20),
                                 color: Colors.white
                               ),
                               child: Text("${double.parse(widget.office['distance'] ).toStringAsFixed(2)} km")
                           ),
                           SizedBox(width: 10,),
                           Container(
                               padding: EdgeInsetsDirectional.symmetric(horizontal: 5),
                               decoration: BoxDecoration(

                                   borderRadius: BorderRadius.circular(20),
                                   color: Colors.white
                               ),
                               child: Text("${double.parse(widget.office['capacity'] ).toStringAsFixed(2)} person")
                           ),
                         ],
                       ),
                       Padding(
                           padding: EdgeInsets.only(right: 30),
                           child: Icon(CupertinoIcons.heart,color: Colors.white,)
                       ),
                     ],
                   ),
                 ),
                 Spacer(),
                 Padding(
                     padding: EdgeInsets.only(left: 20,bottom: 20),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text("${widget.office['name']}",style: myStyle(20,Colors.white,FontWeight.bold),),
                         Text("${widget.office['location']} ${widget.office['city']}",style: whiteStyle(),),
                         SizedBox(height: 20,),
                         Row(
                           children: [
                            MaterialButton(

                              onPressed: (){},
                              height: 40,
                              shape: RoundedRectangleBorder(


                                borderRadius: BorderRadius.circular(30)
                              ),
                              color: maya,
                              child: Text("Book Now",style: whiteStyle(),),

                            ),
                             SizedBox(width: 10,),
                             MaterialButton(

                               onPressed: (){},
                               height: 30,
                               shape: RoundedRectangleBorder(

                                   side: BorderSide(
                                     color: Colors.white
                                   ),
                                   borderRadius: BorderRadius.circular(30)
                               ),
                               color: Colors.transparent,
                               child: Row(
                                 children: [
                                   Icon(CupertinoIcons.map,color: sada,),

                                   Text("  Google Map",style: whiteStyle(),),
                                 ],
                               ),

                             ),
                             SizedBox(width: 10,),
                             MaterialButton(

                               onPressed: (){},
                               height: 30,
                               shape: RoundedRectangleBorder(

                                   side: BorderSide(
                                       color: Colors.white
                                   ),
                                   borderRadius: BorderRadius.circular(30)
                               ),
                               color: Colors.transparent,
                               child: Row(
                                 children: [
                                   Icon(Icons.help_outline,color: sada,),

                                   Text("  Help",style: whiteStyle(),),
                                 ],
                               ),
                             ),
                           ],
                         )
                       ],
                     ),
                 )
               ],
             ),
           ),
           Container(
             padding: EdgeInsets.only(

             ),
           )
         ],
       ),
     ),
    );
  }
}
