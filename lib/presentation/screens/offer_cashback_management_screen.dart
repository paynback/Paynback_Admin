import 'package:flutter/material.dart';

class OfferCashbackManagementScreen extends StatelessWidget {
  const OfferCashbackManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Offer & Cashback Management",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Add Offer logic
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Offer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add Cashback logic
                  },
                  icon: const Icon(Icons.attach_money),
                  label: const Text("Add Cashback"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(
                        index % 2 == 0 ? Icons.local_offer : Icons.money,
                        color: index % 2 == 0 ? Colors.deepPurple : Colors.green,
                      ),
                      title: Text(index % 2 == 0
                          ? "20% Off on Electronics"
                          : "5% Cashback on Groceries"),
                      subtitle: Text("Valid until: 30 Apr 2025"),
                      trailing: TextButton(
                        onPressed: () {
                          // Edit or Remove logic
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
