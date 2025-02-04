import 'package:flutter/material.dart';
import '../NavBar.dart';

class AgentStockOutHistory extends StatelessWidget {
  final List<Map<String, dynamic>> stockData = [
    {
      "name": "Thaqif Sha",
      "id": "DSAG6282",
      "date": "Oct 29, 2024",
      "containers": "10 containers",
      "status": "Pending",
    },
    {
      "name": "Luna Inara",
      "id": "DSAG3112",
      "date": "Oct 29, 2024",
      "containers": "20 containers",
      "status": "Completed",
    },
    {
      "name": "Ahmad Fauzi",
      "id": "DSAG1123",
      "date": "Nov 02, 2024",
      "containers": "5 containers",
      "status": "Completed",
    },
    {
      "name": "Siti Khadijah",
      "id": "DSAG7456",
      "date": "Nov 10, 2024",
      "containers": "15 containers",
      "status": "Pending",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFD966),
        elevation: 0,
        title: Text(
          'Stock In History',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 25,
            color: Colors.black,
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
                  itemCount: stockData.length,
                  itemBuilder: (context, index) {
                    return StockItemCard(stockInfo: stockData[index]);
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
  final Map<String, dynamic> stockInfo;

  const StockItemCard({required this.stockInfo});

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
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.amber[200],
              child: Icon(Icons.person, size: 30, color: Colors.black),
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
                        '${stockInfo["name"]}  |  ${stockInfo["id"]}',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
                      Text(
                        stockInfo["containers"],
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                        ),
                      ),
                      Spacer(),
                      Text(
                        stockInfo["date"],
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
                          color: Colors.grey[600],
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
                        color: stockInfo["status"] == "Completed" ? Colors.green : Colors.orange,
                      ),
                      SizedBox(width: 8),
                      Text(
                        stockInfo["status"],
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 13,
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
