import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widget/custom_widgets.dart';
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Stack(
          children: [
            Container(
              color: Colors.blue.shade100,
            ),
            Column(
              children: [
                Container(
                   padding: EdgeInsets.all(25),
                    child: Row(
                  children: [
                    Expanded(child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: MaterialButton(
                        height:55,
                        onPressed: (){},child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on_outlined,color: Colors.white,),
                          SizedBox(width: 10,),
                          Text("Location",style: TextStyle(color: Colors.white),),
                          SizedBox(width: 10,),
                          Icon(Icons.arrow_circle_down,color: Colors.white,),
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
                        onPressed: (){},child: Row(
                        children: [
                          Icon(FontAwesomeIcons.userPlus,color: Colors.white,),
                          SizedBox(width: 12,),
                          Text("Capacity",style: TextStyle(color: Colors.white),),
                          SizedBox(width: 5,),
                          Icon(CupertinoIcons.minus,size: 12,color: Colors.white,),
                          SizedBox(width: 5,),
                          Text("1",style: TextStyle(color: Colors.white),),
                          SizedBox(width: 5,),
                          Icon(CupertinoIcons.add,size: 12,color: Colors.white,)
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

                      width: 260,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20,left: 20),
                            child: Container(
                              height: 110,
                              width: 260,
                              
                              decoration: BoxDecoration(
                                color: caya,
                                borderRadius: BorderRadius.circular(30)
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex:1,child: Padding(
                                    padding: const EdgeInsets.only( top: 20,bottom: 20,left: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(

                                          image: AssetImage("lib/asset/image/office_1.jpg",),fit: BoxFit.fill)
                                      ),
                                    ),
                                  )),
                                  Expanded(flex:2,child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("The Mall WTC"),
                                        Text("Al Danah - Anu Dhabi"),
                                        SizedBox(height: 5,),
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 3),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(30),
                                                color: Colors.white
                                              ),
                                              child: Text("1 PERSON"),
                                            ),
                                            SizedBox(width: 10,),
                                            Container(
                                              padding: EdgeInsets.only(left: 5,right: 5,top: 3,bottom: 3),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: Colors.white
                                              ),
                                              child: Text("0.2 km"),
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
                                    borderRadius: BorderRadius.circular(30)
                                  ),
                                  onPressed: (){},color: maya,child: Text("Book Now",style: whiteStyle(),),),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("starting at",style: TextStyle(color: Colors.white,fontSize: 10),),
                                      Text("AED 100/hr",style: whiteStyle(),),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
    );
  }
}
