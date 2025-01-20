import 'package:flutter/material.dart';
import 'package:hivetrack_app/EssentialFunctions.dart';
import 'package:intl/intl.dart';
import '../NavBar.dart';

class CompanyAgentManagement extends StatelessWidget {
  final String role;

  CompanyAgentManagement({Key? key, required this.role}) : super(key: key);

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
              future: getUserDataWithParentName(uid), // New Future to get additional data
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
                    future: getAllVerifiedUsersByCID(userData?["user_data"]["company_id"], 0), // New Future to get additional data
                    builder: (context, secondSnapshot) {
                      if (secondSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (secondSnapshot.hasError) {
                        return Center(child: Text('Error: ${secondSnapshot.error}'));
                      } else if (!secondSnapshot.hasData) {
                        return Center(child: Text('No verified user data found.'));
                      } else {
                        final verifiedUserData = secondSnapshot.data;

                        return AgentCard(agents: [
                          for (var entry in verifiedUserData!.values)
                            {
                              'name': entry['name'] ?? 'No Name',
                              'id': entry['id'] ?? 'No ID',
                              'location': entry['address'] ?? 'No Address',
                              'joinedDate': DateFormat('yyyy-MM-dd HH:mm:ss').format(entry['created_at'].toDate()) ?? 'No Address',
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
      )
    );
  }
}


class AgentCard extends StatelessWidget {
  final String role;
  final List<Map<String, String>> agents;

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
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, ID... etc',
                hintStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.filter_alt_outlined),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                      title: Text(
                        agent['name']!,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
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
                              const Icon(Icons.location_on, size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                agent['location']!,
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
                              const Icon(Icons.calendar_month_outlined, size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                'Joined on ${agent['joinedDate']}',
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
                      trailing: PopupMenuButton<String>(
                        onSelected: (String value) {
                          if (value == 'dropship') {
                            // Navigate to Dropship List
                            print('Navigating to Dropship List');
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
        currentIndex: 0, // Set the initial tab index
        role: role, // Pass the role to the NavBar
      ),
    );
  }
}