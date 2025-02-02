import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hivetrack_app/EssentialFunctions.dart';
import '../NavBar.dart';

class AgentsMapDropship extends StatefulWidget {
  const AgentsMapDropship({super.key});

  @override
  State<AgentsMapDropship> createState() => _AgentsMapDropshipState();
}

class _AgentsMapDropshipState extends State<AgentsMapDropship> {
  late GoogleMapController _mapController;
  LatLng? _selectedAgentLocation;
  bool _isStatusVisible = false;
  String _statusText = "Activity Status";
  Map<String, dynamic> _selectedAgent = {};

  Future<List<Map<String, dynamic>>> _getAgents() async {
    try {
      final agentUID = await getCurrentAuthUserId();
      Map<String, dynamic> userData = await getUserDataWithParentName(agentUID!);

      QuerySnapshot agentsSnapshot = await FirebaseFirestore.instance.collection('Dropship_Agent').get();

      List<dynamic> validUsersID = userData["user_data"]["covered_agent"] ?? [];
      print("JAGGER");
      print(validUsersID);
      List<Map<String, dynamic>> agents = [];
      for (var doc in agentsSnapshot.docs) {
        if (validUsersID.contains(doc.id)) {
          Map<String, dynamic> agentData = doc.data() as Map<String, dynamic>;
          String address = agentData['address'] ?? "";

          LatLng location = await _getGeoLocationFromAddress(address);

          agentData['latitude'] = location.latitude;
          agentData['longitude'] = location.longitude;

          agents.add(agentData);
        }
      }

      return agents;
    } catch (e) {
      print("Error fetching agents: $e");
      return [];
    }
  }

  Future<LatLng> _getGeoLocationFromAddress(String address) async {
    try {
      // Using geocoding to get coordinates from address
      List<Location> locations = await locationFromAddress(address);
      return LatLng(locations[0].latitude, locations[0].longitude);
    } catch (e) {
      print("Error getting geolocation: $e");
      return LatLng(0.0, 0.0); // Default location if error
    }
  }

  void _toggleStatus(Map<String, dynamic> agent) {
    setState(() {
      if (_selectedAgent["id"] == agent["id"] && _isStatusVisible) {
        _isStatusVisible = false;
        _statusText = "Activity Status";
        _selectedAgent = {};
      } else {
        _isStatusVisible = true;
        _statusText = "Delivery Status";
        _selectedAgent = agent;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dropship Agents',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFFFBD46D),
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _getAgents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error fetching agents: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No agents available');
                    }

                    final agents = snapshot.data!;

                    final Set<Marker> markers = agents.map((entry) {
                      final agentName = entry['name'] ?? "Unknown";
                      final agentId = entry['id'] ?? "Unknown";
                      final double lat = entry['latitude'] ?? 0.0;
                      final double lng = entry['longitude'] ?? 0.0;

                      return Marker(
                        markerId: MarkerId(agentName),
                        position: LatLng(lat, lng),
                        icon: BitmapDescriptor.defaultMarkerWithHue(entry["AwaitedJars"] is List && entry["AwaitedJars"].length == 0 ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueYellow),
                        onTap: () => _toggleStatus(entry),
                      );
                    }).toSet();

                    // Return GoogleMap widget with dynamically generated markers
                    return GoogleMap(
                      onMapCreated: (GoogleMapController controller) async {
                        _mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(agents.first['latitude'], agents.first['longitude']),
                        zoom: 14,
                      ),
                      markers: markers, // Use dynamically generated markers
                    );
                  },
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.amber[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          _statusText,
                          style: const TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isStatusVisible ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() {
                            _isStatusVisible = !_isStatusVisible;
                            _statusText = _isStatusVisible ? "Delivery Status" : "Activity Status";
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (_isStatusVisible && _selectedAgent != {})
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.amber.shade100,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(-43, -30), // Move text upward by 5 pixels
                          child: Padding(
                            padding: const EdgeInsets.only(right: 60.0),
                            child: Text(
                              'Dropship Agent: ${_selectedAgent["id"]}',
                              style: const TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person, size: 28, color: Colors.black),
                                  Text('You', style: TextStyle(fontFamily:'Roboto', fontSize: 14)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_shipping, size: 28, color: Colors.black),
                                  Text('Delivery', style: TextStyle(fontFamily:'Roboto',fontSize: 14)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_pin_circle_rounded, size: 28, color: Colors.black),
                                  Text('${_selectedAgent["name"]}', style: const TextStyle(fontFamily:'Roboto',fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0,
        role: 'Agent',
      ),
    );
  }
}

class DropshipAgent {
  final String name;
  final int containers;
  final String status;
  final LatLng location;

  DropshipAgent({required this.name, required this.containers, required this.status, required this.location});
}
