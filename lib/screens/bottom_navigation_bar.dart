import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:office_booking/pages/book_now.dart';
import 'package:office_booking/pages/home.dart';
import 'package:office_booking/pages/office_list.dart';

import 'package:office_booking/pages/office_view.dart';
import 'package:office_booking/pages/search.dart';
import 'package:office_booking/screens/account.dart';

import '../widget/custom_widgets.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> pages = [
    Home(),
    Search(),
    BookNow(),
    OfficeView(),
    UserAccount(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: ConvexAppBar(


        initialActiveIndex: currentIndex,
        style: TabStyle.fixed,
        backgroundColor: caya,

        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.map, title: 'Discovery'),
          TabItem(
              icon: CircleAvatar(

            child: Container(

              child: Icon(Icons.add,color: Colors.white,),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: Colors.white
                )
              ),
            ),
            backgroundColor: maya,
          ), title: 'BOOK NOW',),
          TabItem(icon: Icons.message, title: 'Message'),
          TabItem(icon: Icons.people, title: 'Profile',),
        ],
        onTap: (value){
          setState(() {
            currentIndex = value;
          });
        },
      )
    );
  }
}
