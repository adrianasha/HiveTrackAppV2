import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class DropshipHistory extends StatelessWidget {
  const DropshipHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBD46D),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Inventory History',
          style: TextStyle(fontFamily: 'Roboto', fontSize: 25, color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButton(label: 'Stock In', isSelected: false),
                const SizedBox(width: 10),
                ToggleButton(label: 'Stock Out', isSelected: true),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                InventoryCard(
                  id: 'AG1005',
                  date: 'Nov 15, 2024',
                  jars: 30,
                  status: 'Pending',
                ),
                HistoryCard(quantity: '2 Jars', date: 'Oct 28, 2024'),
                HistoryCard(quantity: '1 Jar', date: 'Oct 29, 2024'),
                InventoryCard(
                  id: 'AG1005',
                  date: 'Oct 10, 2024',
                  jars: 30,
                  status: 'Completed',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.amber.shade400,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.mail), label: 'Inbox'),
          BottomNavigationBarItem(
              icon: Icon(LucideIcons.bell), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const ToggleButton({
    Key? key,
    required this.label,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.amber.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class InventoryCard extends StatelessWidget {
  final String id;
  final String date;
  final int jars;
  final String status;

  const InventoryCard({
    Key? key,
    required this.id,
    required this.date,
    required this.jars,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.shopping_cart, size: 40, color: Colors.black54),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    id,
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.inbox, size: 16, color: Colors.black54),
                      const SizedBox(width: 4),
                      Text('$jars Jars',
                        style: TextStyle(fontFamily: 'Roboto', fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        status == 'Pending' ? Icons.hourglass_top : Icons.check_circle,
                        size: 16,
                        color: status == 'Pending' ? Colors.orange : Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: status == 'Pending' ? Colors.orange : Colors.green,
                          fontWeight: FontWeight.bold, fontFamily: 'Roboto', fontSize: 13
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              date,
              style: TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String quantity;
  final String date;

  const HistoryCard({
    Key? key,
    required this.quantity,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle,
              size: 40,
              color: Colors.black54,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                quantity,
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              date,
              style: TextStyle(fontFamily: 'Roboto', fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
