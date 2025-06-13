// lib/screens/commission_management_screen.dart

import 'package:flutter/material.dart';

class CommissionManagementScreen extends StatelessWidget {
  const CommissionManagementScreen({super.key});

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
              "Commission Management",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Add Commission logic
              },
              icon: const Icon(Icons.add_chart),
              label: const Text("Set Commission Rate"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Icon(Icons.storefront, color: Colors.white),
                      ),
                      title: Text("Merchant #${index + 1}"),
                      subtitle: Text("Commission Rate: ${5 + index}%"),
                      trailing: TextButton(
                        onPressed: () {
                          // Update logic
                        },
                        child: const Text(
                          "Update",
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
