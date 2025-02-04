import 'package:flutter/material.dart';
import '../NavBar.dart';

class AgentStockInHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFD966),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Stock In History',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 2,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.only(bottom: 16),
            elevation: 3,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.apartment, size: 30, color: Colors.grey),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'HoneyBee .Co',
                          style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.shopping_cart, size: 16),
                                SizedBox(width: 4),
                                Text('5 Boxes',
                                  style: TextStyle(fontFamily: 'Roboto', fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.store, size: 16),
                                SizedBox(width: 4),
                                Text('30 Jars',
                                  style: TextStyle(fontFamily: 'Roboto', fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  index == 0
                                      ? Icons.pending_actions
                                      : Icons.check_circle,
                                  size: 16,
                                  color: index == 0 ? Colors.orange : Colors.green,
                                ),
                                SizedBox(width: 4),
                                Text(index == 0 ? 'Pending' : 'Completed',
                                  style: TextStyle(fontFamily: 'Roboto', fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0), // Adjust the value as needed
                        child: Icon(Icons.more_horiz_rounded, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Nov ${15 - (index * 5)}, 2024',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0,
        role: 'Agent',
      ),
    );
  }
}
