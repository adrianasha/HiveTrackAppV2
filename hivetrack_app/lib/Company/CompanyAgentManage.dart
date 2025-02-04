import 'package:flutter/material.dart';
import 'package:hivetrack_app/EssentialFunctions.dart';
import 'package:intl/intl.dart';
import '../NavBar.dart';

class CompanyAgentManagement extends StatelessWidget {
  final String role;

  // final List<Map<String, String>> agents = [
  //   {
  //     'name': 'Alisya Tomes',
  //     'id': 'AG1004',
  //     'location': 'Serdang, Selangor',
  //     'joinedDate': '9/12/2024',
  //   },
  //   {
  //     'name': 'Moonna Zul',
  //     'id': 'AG1003',
  //     'location': 'Shah Alam, Selangor',
  //     'joinedDate': '11/11/2024',
  //   },
  //   {
  //     'name': 'Toqip Kot',
  //     'id': 'AG1002',
  //     'location': 'Petaling Jaya, Selangor',
  //     'joinedDate': '06/11/2024',
  //   },
  //   {
  //     'name': 'Luna Cen',
  //     'id': 'AG1001',
  //     'location': 'Cheras, Kuala Lumpur',
  //     'joinedDate': '05/11/2024',
  //   },
  // ];

  CompanyAgentManagement({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String?>(
        future: getCurrentAuthUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No agents found.'));
          } else {
            final uid = snapshot.data!;
            return FutureBuilder<Map<String, dynamic>>(
              future: getUserDataWithParentName(uid),
              builder: (context, secondSnapshot) {
                if (secondSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (secondSnapshot.hasError) {
                  return Center(child: Text('Error: ${secondSnapshot.error}'));
                } else if (!secondSnapshot.hasData) {
                  return Center(child: Text('No verified user data found.'));
                } else {
                  final userData = secondSnapshot.data;

                  return FutureBuilder<Map<String, dynamic>>(
                    future: getAllVerifiedUsersByCID(userData?["user_data"]["company_id"], 0),
                    builder: (context, thirdSnapshot) {
                      if (thirdSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (thirdSnapshot.hasError) {
                        return Center(child: Text('Error: ${thirdSnapshot.error}'));
                      } else if (!thirdSnapshot.hasData) {
                        return Center(child: Text('No verified user data found.'));
                      } else {
                        final verifiedUserData = thirdSnapshot.data;

                        return AgentCard(agents: [
                          for (var entry in verifiedUserData!.values)
                            {
                              'name': entry['name'] ?? 'No Name',
                              'id': entry['id'] ?? 'No ID',
                              'location': entry['address'] ?? 'No Address',
                              'joinedDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(entry['created_at'].toDate()) ?? 'No joinDate',
                              'covered_agent': entry["covered_agent"],
                            }
                        ], role: role);
                      }
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}

class AgentCard extends StatelessWidget {
  final String role;
  final List<Map<String, dynamic>> agents;

  const AgentCard({Key? key, required this.agents, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Honey Agent',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
        ),
        backgroundColor: Colors.amber[300],
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 20.0, 16.0, 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, ID... etc',
                hintStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.grey,
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.filter_alt_outlined),
                border: const UnderlineInputBorder(), // Horizontal line as underline
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.amber, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: agents.length,
              itemBuilder: (context, index) {
                final agent = agents[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Colors.white38, width: 2.0),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                      title: Text(
                        agent['name']!,
                        style: const TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.account_box, size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                agent['id']!,
                                style: const TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              FutureBuilder<Map<String, String>>(
                                future: getCityAndRegion(agent['location']!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); // Show loading indicator
                                  } else if (snapshot.hasError) {
                                    return const Text("Error fetching address");
                                  } else if (snapshot.hasData) {
                                    final data = snapshot.data!;
                                    String? city = data['city'];
                                    String? region = data['region'];
                                    return Flexible(
                                      child: Text(
                                        "$city, $region",
                                        style: const TextStyle(fontFamily: 'Roboto', fontSize: 12, color: Colors.black,
                                        ),
                                        maxLines: 2, // Limit to 2 lines
                                        overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                                      ),
                                    );
                                  } else {
                                    return const Text("No address found");
                                  }
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined, size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                'Joined on ${agent['joinedDate']}',
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) {
                          if (value == 'dropship') {
                            showDialog(
                              context: context,
                              builder: (context) => DropshipListPopup(agent: agent),
                            );
                          } else if (value == 'delete') {
                            // Handle delete action
                            print('Deleting Agent');
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'dropship',
                              child: Row(
                                children: const [
                                  Icon(Icons.list, size: 20, color: Colors.black54),
                                  SizedBox(width: 8),
                                  Text('Dropship List',
                                    style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: const [
                                  Icon(Icons.delete, size: 20, color: Colors.black45),
                                  SizedBox(width: 8),
                                  Text('Delete Agent',
                                    style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0,
        role: role,
      ),
    );
  }
}

class DropshipListPopup extends StatelessWidget {
  final Map<String, dynamic> agent;

  const DropshipListPopup({Key? key, required this.agent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String agentID = agent["id"] ?? "Unknown";
    print("agent fr ");
    print(agent);
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 320, // Width of the popup
        height: 535, // Adjusted height to accommodate buttons
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dropship Agent List',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Agent: $agentID',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  if (agent["covered_agent"] != null && agent["covered_agent"]!.isNotEmpty && agent["covered_agent"]!.length > 0) ...[
                    ...agent["covered_agent"]!.map((agentId) {
                      return FutureBuilder<Map<String, dynamic>>(
                        future: getUserDataWithParentName(agentId), // Call your async function
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show a loading indicator
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text('No items available');
                          }

                          final agentData = snapshot.data!["user_data"];

                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.amber[50], // Background color
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.only(bottom: 8.0), // Spacing between boxes
                            child: ListTile(
                              title: Text(
                                agentData["name"],
                                style: TextStyle(fontFamily: 'Roboto', fontSize: 15, fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${agentData["id"]}',
                                    style: TextStyle(fontFamily: 'Roboto', fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    agentData["address"].length > 30
                                        ? agentData["address"].substring(0, 30) + '...'
                                        : agentData["address"],
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Joined on ${DateFormat('yyyy-MM-dd HH:mm:ss').format(agentData['created_at'].toDate()) ?? 'No joinDate'}',
                                    style: TextStyle(fontFamily: 'Roboto', fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  DeleteButton(
                                    onDelete: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Luna Inara deleted!')),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList()
                  ] else ...[
                    Text(
                      'No Dropships',
                      style: TextStyle(fontFamily: 'Roboto', fontSize: 15, fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ],
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Close',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.amber, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DeleteButton extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteButton({Key? key, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onDelete,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange[200],
      ),
      child: const Text(
        'Delete Agent',
        style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.white),
      ),
    );
  }
}
