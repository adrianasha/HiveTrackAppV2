import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../NavBar.dart';

class CompanyRegionalSales extends StatefulWidget {
  final String role; // Add the role parameter

  const CompanyRegionalSales({Key? key, required this.role}) : super(key: key);

  @override
  _CompanyRegionalSalesState createState() => _CompanyRegionalSalesState();
}

class _CompanyRegionalSalesState extends State<CompanyRegionalSales> {
  GoogleMapController? mapController;

  // Define the initial position for the map
  static const LatLng _initialPosition = LatLng(3.132582, 101.769360); // Example: Taman Connaught coordinates

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: const Text(
          'Regional Sales',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 25,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
      ),
      backgroundColor: Colors.white, // Set the background color to white
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Demand Analysis',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Rounded corners for the map container
              child: SizedBox(
                height: 300, // Set the height of the map
                child: GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller; // Get the map controller
                  },
                  initialCameraPosition: const CameraPosition(
                    target: _initialPosition,
                    zoom: 14, // Set the zoom level for the map
                  ),
                  markers: <Marker>{
                    Marker(
                      markerId: const MarkerId('location'),
                      position: _initialPosition,
                      infoWindow: const InfoWindow(title: 'Taman Connaught'),
                    ),
                  },
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16, left: 16),
            child: Text(
              'Pie Chart',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(), // Pushes the map and text up to make space for the navbar
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2, // Set index for Regional Sales
        role: widget.role, // Pass the role to the NavBar
      ),
    );
  }
}
