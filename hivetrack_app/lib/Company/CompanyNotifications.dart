import 'package:flutter/material.dart';
import 'package:hivetrack_app/EssentialFunctions.dart';
import '../NavBar.dart';
import 'CompanyAgentRequest.dart'; // Import the page to navigate to

class CompanyNotifications extends StatelessWidget {
  final String role; // Add the role parameter for the NavBar

  CompanyNotifications({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getCurrentAuthUserId(),
      builder: (context, userIdSnapshot) {
        if (userIdSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (userIdSnapshot.hasError) {
          return Center(child: Text('Error: ${userIdSnapshot.error}'));
        }

        if (!userIdSnapshot.hasData || userIdSnapshot.data == null) {
          return Center(child: Text('User not authenticated.'));
        }

        // Fetch user data and company ID based on UserId
        String userId = userIdSnapshot.data!;
        return FutureBuilder<Map<String, dynamic>>(
          future: getUserDataWithParentName(userId),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (dataSnapshot.hasError) {
              return Center(child: Text('Error: ${dataSnapshot.error}'));
            }

            if (!dataSnapshot.hasData || dataSnapshot.data == null) {
              return Center(child: Text('Failed to fetch user data.'));
            }

            Map<String, dynamic> userData = dataSnapshot.data!;
            String companyId = userData["user_data"]["company_id"];

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.amber[300],
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // Use pop to go back to the previous page
                  },
                ),
                title: Text(
                  'Notifications',
                  style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black),
                ),
                elevation: 0,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<Map<String, dynamic>>(
                        future: getAllUnverifiedUsersByCID(companyId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          }

                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            final unverifiedData = snapshot.data!;
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: unverifiedData.entries.map((entry) {
                                  String role = entry.key; // "Agent", "Dropship_Agent", etc.
                                  List<Map<String, dynamic>> requests = [Map<String, dynamic>.from(entry.value)];

                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$role Requests',
                                        style: TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black),
                                      ),
                                      SizedBox(height: 16),
                                      ...requests.map((request) {
                                        List<RequestTile> rows = [];
                                        for (var entry in request.entries) {
                                          entry.value["user_id"] = entry.key;
                                          entry.value["role"] = role;
                                          print(entry.value);
                                          rows.add(RequestTile(
                                            name: entry.value['name'] ?? 'Unknown',
                                            subtitle: 'is requesting to be a $role...',
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => CompanyAgentRequest(dataMap: entry.value)), // Customize navigation if needed
                                              );
                                            },
                                          ));
                                        }

                                        return Column(
                                          children: [...rows],
                                        );
                                      }).toList(),
                                      SizedBox(height: 32),
                                    ],
                                  );
                                }).toList(),
                              ),
                            );
                          }

                          return Center(child: Text('No notifications found.',
                            style: TextStyle(fontFamily: 'Roboto', fontSize: 14, color: Colors.grey),));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: NavBar(
                currentIndex: 1, // Set the index for the Notifications tab (assuming index 1 for this example)
                role: role, // Pass the role to the reusable NavBar
              ),
            );
          },
        );
      },
    );
  }
}

class RequestTile extends StatelessWidget {
  final String name;
  final String subtitle;
  final VoidCallback onTap;

  const RequestTile({
    required this.name,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(name, style: TextStyle(fontFamily: 'Roboto', fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.black)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap, // Use the provided onTap callback
      ),
    );
  }
}
