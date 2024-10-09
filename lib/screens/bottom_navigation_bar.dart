import 'package:flutter/material.dart';
import 'package:office_booking/pages/home.dart';
import 'package:office_booking/pages/office_list.dart';

import 'package:office_booking/pages/office_view.dart';
import 'package:office_booking/screens/account.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> pages = [
    Home(),
    OfficeList(),
    UserAccount(),
  ];
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: pages[currentIndex],
      ),
   bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
     items: [
       BottomNavigationBarItem(icon: Icon(Icons.home_filled),label: "Office"),
       BottomNavigationBarItem(icon: Icon(Icons.book_online),label: "Booking"),
       BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded),label: "Account"),
     ],
        )
    );
  }
}
