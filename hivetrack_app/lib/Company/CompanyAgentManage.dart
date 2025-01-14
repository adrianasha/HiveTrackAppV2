import 'package:flutter/material.dart';
import 'CompanyNavBar.dart';

class CompanyAgentManagement extends StatelessWidget {
  final List<Map<String, String>> agents = [
    {
      'name': 'Alisya Tomes',
      'id': 'AG1004',
      'location': 'Serdang, Selangor',
      'joinedDate': '9/12/2024',
    },
    {
      'name': 'Moonna Zul',
      'id': 'AG1003',
      'location': 'Shah Alam, Selangor',
      'joinedDate': '11/11/2024',
    },
    {
      'name': 'Toqip Kot',
      'id': 'AG1002',
      'location': 'Petaling Jaya, Selangor',
      'joinedDate': '06/11/2024',
    },
    {
      'name': 'Luna Cen',
      'id': 'AG1001',
      'location': 'Cheras, Kuala Lumpur',
      'joinedDate': '05/11/2024',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agent Management',
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
                hintStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Colors.grey),
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
                        style: const TextStyle(fontFamily: 'Roboto', fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
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
                                style: const TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                agent['location']!,
                                style: const TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.calendar_month_outlined, size: 16, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                'Joined on ${agent['joinedDate']}',
                                style: const TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.more_vert),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CompanyNavBar(
        currentIndex: 0, // Set the initial tab index
      ),
    );
  }
}
