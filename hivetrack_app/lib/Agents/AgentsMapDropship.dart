import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../NavBar.dart';

class AgentsMapDropship extends StatefulWidget {
  const AgentsMapDropship({super.key});

  @override
  State<AgentsMapDropship> createState() => _AgentsMapDropshipState();
}

class _AgentsMapDropshipState extends State<AgentsMapDropship> {
  final List<DropshipAgent> _agents = [
    DropshipAgent(
      name: 'Thaqif Sha',
      containers: 18,
      status: 'Completed',
      location: LatLng(3.1400, 101.6869),
    ),
    DropshipAgent(
      name: 'Luna Inara',
      containers: 12,
      status: 'Pending',
      location: LatLng(3.1420, 101.6880),
    ),
  ];

  late GoogleMapController _mapController;

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
          // Delivery Status Footer (rendered first so it gets overlapped)
          // Add this to the Positioned widget for the Delivery Status Footer
          Positioned(
            bottom: 80, // Adjusted for the lower part
            left: 16,
            right: 16,
            child: Column(
              children: [
                Container(
                  height: 80, // Delivery Status footer height
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBD46D),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Delivery Status",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8), // Space between containers
                // Add lower section here
                Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person, size: 28, color: Colors.black),
                          SizedBox(height: 4),
                          Text(
                            'Dropship Agent',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.local_shipping, size: 28, color: Colors.black),
                          SizedBox(height: 4),
                          Text(
                            'Delivery',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.store_mall_directory_outlined, size: 28, color: Colors.black),
                          SizedBox(height: 4),
                          Text(
                            'Mall',
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 14,
                              color: Colors.black,
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
          // Map Section with curved borders (overlapping the Delivery Status)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0), // Rounded corners
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 400,
                      child: GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: LatLng(3.1390, 101.6869), // Kuala Lumpur coordinates
                          zoom: 12.0,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                        markers: _agents
                            .map(
                              (agent) => Marker(
                            markerId: MarkerId(agent.name),
                            position: agent.location,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              agent.status == 'Pending'
                                  ? BitmapDescriptor.hueYellow
                                  : BitmapDescriptor.hueGreen,
                            ),
                          ),
                        )
                            .toSet(),
                      ),
                    ),
                    // Custom Agent Information Windows
                    Positioned(
                      top: 50,
                      left: 20,
                      child: _buildAgentInfoWindow(_agents[0]),
                    ),
                    Positioned(
                      bottom: 300, // Adjusted to avoid full overlap with footer
                      right: 70,
                      child: _buildAgentInfoWindow(_agents[1]),
                    ),
                  ],
                ),
              ),
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

  Widget _buildAgentInfoWindow(DropshipAgent agent) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            agent.name,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.shopping_cart, size: 16),
              const SizedBox(width: 4),
              Text(
                '${agent.containers} containers',
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                agent.status == 'Completed' ? Icons.check_circle : Icons.hourglass_empty,
                size: 16,
                color: agent.status == 'Completed' ? Colors.green : Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                agent.status,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DropshipAgent {
  final String name;
  final int containers;
  final String status;
  final LatLng location;

  DropshipAgent({
    required this.name,
    required this.containers,
    required this.status,
    required this.location,
  });
}
