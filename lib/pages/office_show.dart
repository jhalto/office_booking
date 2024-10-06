import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:office_booking/custom_http/custom_http_request.dart';
import 'package:office_booking/key/api_key.dart';
import 'package:http/http.dart' as http;
import 'package:office_booking/model_class/office_model.dart';

class OfficeShow extends StatefulWidget {
  const OfficeShow({super.key});

  @override
  State<OfficeShow> createState() => _OfficeShowState();
}

class _OfficeShowState extends State<OfficeShow> {
  // Store office data for each office (5 pages)
  List<Data?> officeDataList = List.filled(5, null);
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load the office data for the first page (index 1)
    getOfficeList(1); // Starts from 1
  }

  getOfficeList(int pageIndex) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Adjust index to match API (starts from 1)
      var url = "${baseUrlDrop}office/$pageIndex?lat=25.3899&lon=88.9916&date=2024-09-11";
      var response = await http.get(Uri.parse(url),
          headers: await CustomHttpRequest.getHeaderWithToken());

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == true) {
          // Parse the JSON response into the OfficeModel
          OfficeModel officeModel = OfficeModel.fromJson(jsonResponse);
          setState(() {
            officeDataList[pageIndex - 1] = officeModel.data; // Adjust for the list index (starts from 0)
          });
        } else {
          print("Failed to load office at index $pageIndex");
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Something went wrong: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Office Details')),
      body: PageView.builder(
        itemCount: officeDataList.length,
        controller: PageController(initialPage: 0), // Starts the view from the 1st page
        onPageChanged: (int pageIndex) {
          int adjustedIndex = pageIndex + 1; // Adjust for API index (1-based)
          if (officeDataList[pageIndex] == null) {
            // Fetch the office data for the new page if not already loaded
            getOfficeList(adjustedIndex);
          }
        },
        itemBuilder: (context, pageIndex) {
          return isLoading && officeDataList[pageIndex] == null
              ? Center(child: CircularProgressIndicator())
              : officeDataList[pageIndex] != null
              ? buildOfficeDetails(officeDataList[pageIndex]!)
              : Center(child: Text('No data available'));
        },
      ),
    );
  }

  Widget buildOfficeDetails(Data officeData) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Office Name
            Text(
              officeData.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Short Description
            Text(officeData.shortDescription),
            SizedBox(height: 10),

            // Location
            Text("Location: ${officeData.location}"),
            SizedBox(height: 10),

            // Price and Currency
            Text("Price per hour: ${officeData.pricePerHr} ${officeData.currency}"),
            SizedBox(height: 10),

            // Capacity
            Text("Capacity: ${officeData.capacity} person(s)"),
            SizedBox(height: 10),

            // Office Photos (with image fallback)
            officeData.photos.isNotEmpty
                ? Image.network(
              baseUrlDrop + officeData.photos[0].url,
              errorBuilder: (context, error, stackTrace) {
                return Text('Image could not be loaded');
              },
            )
                : Container(
              child: Text('No image available'),
              height: 150,
              color: Colors.grey[200],
            ),
            SizedBox(height: 20),

            // Facilities Section
            Text(
              'Facilities:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...officeData.facilities.map<Widget>((facility) {
              return ListTile(
                leading: Icon(Icons.check_circle),
                title: Text(facility.name),
                subtitle: Text(facility.description),
              );
            }).toList(),

            SizedBox(height: 20),

            // Menu Section
            Text(
              'Menu:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...officeData.menus.map<Widget>((menu) {
              return ListTile(
                leading: Image.network(
                  baseUrlDrop + menu.image,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 50,
                      height: 50,
                      color: Colors.grey[300],
                      child: Icon(Icons.fastfood),
                    );
                  },
                ),
                title: Text(menu.name),
                subtitle: Text(menu.description),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
