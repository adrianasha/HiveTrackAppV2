import 'package:flutter/material.dart';

import '../NavBar.dart';

class AgentStockOutHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFD966),
        elevation: 0,
        title: Text(
          'Stock In History',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: 5, // Replace with your dynamic list count
                  itemBuilder: (context, index) {
                    return StockItemCard(
                      name: index % 2 == 0 ? "Thaqif Sha" : "Luna Inara",
                      id: index % 2 == 0 ? "DSAG6282" : "DSAG3112",
                      date: "Oct 29, 2024",
                      containers: index % 2 == 0 ? "10 containers" : "20 containers",
                      status: index % 2 == 0 ? "Pending" : "Completed",
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 0,
        role: 'Agent',
      ),
    );
  }
}

class StockItemCard extends StatelessWidget {
  final String name;
  final String id;
  final String date;
  final String containers;
  final String status;

  const StockItemCard({
    required this.name,
    required this.id,
    required this.date,
    required this.containers,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$name  |  $id',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.more_horiz_rounded, color: Colors.grey),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.shopping_cart, size: 18, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(containers,
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 13,
                        ),
                      ),
                      Spacer(),
                      Text(
                        date,
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: status == "Completed" ? Colors.green : Colors.orange,
                      ),
                      SizedBox(width: 8),
                      Text(status,
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 13,
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
    );
  }
}
