import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hivetrack_app/EssentialFunctions.dart';
import 'package:hivetrack_app/WebSocketService.dart';
import '../NavBar.dart';

class CompanyRegionalSales extends StatefulWidget {
  final String role;

  const CompanyRegionalSales({Key? key, required this.role}) : super(key: key);

  @override
  _CompanyRegionalSalesState createState() => _CompanyRegionalSalesState();
}

class _CompanyRegionalSalesState extends State<CompanyRegionalSales> {
  GoogleMapController? mapController;

  static const LatLng _initialPosition = LatLng(3.160213, 101.725201);
  static const LatLng _secondPosition = LatLng(3.162000, 101.725500);


  Future<List<Map<String, dynamic>>> _getAgents() async {
    try {
      // Get agents collection
      QuerySnapshot agentsSnapshot = await FirebaseFirestore.instance.collection('Agent').get();

      // Fetch and convert address to latitude and longitude for each agent
      List<Map<String, dynamic>> agents = [];
      for (var doc in agentsSnapshot.docs) {
        Map<String, dynamic> agentData = doc.data() as Map<String, dynamic>;
        String address = agentData['address'] ?? "";

        // Convert address to geo-location (latitude and longitude)
        LatLng location = await _getGeoLocationFromAddress(address);

        // Update agent data with latitude and longitude
        agentData['latitude'] = location.latitude;
        agentData['longitude'] = location.longitude;

        agents.add(agentData);
      }

      return agents;
    } catch (e) {
      print("Error fetching agents: $e");
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _getDropshipAgents() async {
    try {
      // Get dropship agents collection
      QuerySnapshot dropshipAgentsSnapshot = await FirebaseFirestore.instance.collection('Dropship_Agent').get();

      // Fetch and convert address to latitude and longitude for each dropship agent
      List<Map<String, dynamic>> dropshipAgents = [];
      for (var doc in dropshipAgentsSnapshot.docs) {
        Map<String, dynamic> dropshipAgentData = doc.data() as Map<String, dynamic>;
        String address = dropshipAgentData['address'] ?? "";

        // Convert address to geo-location (latitude and longitude)
        LatLng location = await _getGeoLocationFromAddress(address);

        // Update dropship agent data with latitude and longitude
        dropshipAgentData['latitude'] = location.latitude;
        dropshipAgentData['longitude'] = location.longitude;

        dropshipAgents.add(dropshipAgentData);
      }

      return dropshipAgents;
    } catch (e) {
      print("Error fetching dropship agents: $e");
      return [];
    }
  }

// Method to get geolocation (latitude and longitude) from address
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
  // Custom function to show additional details in a popup
  Future<void> _showDetailsPopup(BuildContext context, String title, String agent, Map<String,dynamic> agentData, String id) async {
    String parentAgentName = "Unknown";
    List<String> dropshipAgentsList = [];

    if (id.contains("DSAG") && agentData["selected_agent"] != null) {
      final parentData = await WebSocketService().sendMessageAndWaitForResponse({ "type": "fetchDropShipAgentParentName", "uid": agentData["selected_agent"] });

      bool succeed = parentData["success"] ?? false;
      if (succeed == true && parentData["ParentUserName"] != null) {
        parentAgentName = parentData["ParentUserName"];
      }
    } else if (id.contains("AG") && agentData["covered_agent"] != null) {
      // Create a list of Future objects to be awaited
      List<Future<void>> futures = [];

      agentData["covered_agent"].forEach((agentId) {
        futures.add(FirebaseFirestore.instance.collection("Dropship_Agent").doc(agentId).get().then((snapshot) {
          if (snapshot.exists) {
            final dropshipAgentDATA = snapshot.data() as Map<String, dynamic>;
            if (dropshipAgentDATA["name"] != null && dropshipAgentDATA["id"] != null) {
              String name = dropshipAgentDATA["name"];
              String id = dropshipAgentDATA["id"];

              String newString = "$name | $id";
              dropshipAgentsList.add(newString);
            }
          }
        }));
      });

      await Future.wait(futures);
    }
    print(dropshipAgentsList);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title,
              style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold)
            ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: $agent | $id',
                  style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.normal)),
              SizedBox(height: 8),
              if (id.contains("DSAG"))
                Text('Dropship Agent to: $parentAgentName',
                    style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.normal),
                )
              else
                Column(
                  children: dropshipAgentsList.map((agent) {
                    return Text(
                      'Dropship Agent to: $agent',
                      style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.normal),
                    );
                  }).toList(),
                )
            ],
          ),
          actions: [
            TextButton(
              child: Text('Close', style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.normal),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[300],
        title: const Text(
          'Regional Sales',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Agents and Dropships',
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
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 620,
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

                    // List of agents
                    final agents = snapshot.data!;

                    return FutureBuilder<List<Map<String, dynamic>>>(
                      future: _getDropshipAgents(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          return Text('Error fetching dropship agents: ${snapshot.error}');
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No dropship agents available');
                        }

                        final dropshipAgents = snapshot.data!;

                        final allAgents = [...agents, ...dropshipAgents];

                        final Set<Marker> markers = allAgents.map((entry) {
                          final agentName = entry['name'] ?? "Unknown";
                          final agentId = entry['id'] ?? "Unknown";
                          final double lat = entry['latitude'] ?? 0.0;
                          final double lng = entry['longitude'] ?? 0.0;

                          return Marker(
                            markerId: MarkerId(agentId),
                            position: LatLng(lat, lng),
                            infoWindow: InfoWindow(
                              title: agentId.contains("DSAG") ? 'Dropship Agent' : 'Agent',
                              snippet: '$agentName | $agentId',
                              onTap: () async {
                                await _showDetailsPopup(
                                  context,
                                  agentId.contains("DSAG") ? 'Dropship Agent' : 'Honey Agent',
                                  agentName,
                                  entry,
                                  agentId,
                                );
                              },
                            ),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              agentId.contains("DSAG") ? BitmapDescriptor.hueYellow : BitmapDescriptor.hueOrange,
                            ),
                          );
                        }).toSet();

                        // Return GoogleMap widget with dynamically generated markers
                        return GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                          initialCameraPosition: CameraPosition(
                            target: LatLng(allAgents.first['latitude'], allAgents.first['longitude']),
                            zoom: 14,
                          ),
                          markers: markers, // Use dynamically generated markers
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2,
        role: widget.role,
      ),
    );
  }
}
