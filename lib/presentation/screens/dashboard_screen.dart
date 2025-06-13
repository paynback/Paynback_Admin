
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'title': 'Total Users', 'count': '1,230', 'icon': Icons.people, 'color': Colors.blue},
      {'title': 'Total Merchants', 'count': '320', 'icon': Icons.store, 'color': Colors.deepPurple},
      {'title': 'Cashback Given', 'count': '\$45,000', 'icon': Icons.card_giftcard, 'color': Colors.green},
      {'title': 'Commission Earned', 'count': '\$7,000', 'icon': Icons.percent, 'color': Colors.orange},
      {'title': 'Sales', 'count': '\$7,0000', 'icon': Icons.shopping_cart, 'color': Colors.pinkAccent},
    ];

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard Overview Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          GridView.builder(
            itemCount: stats.length,
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              final stat = stats[index];
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: stat['color'] as Color,
                      child: Icon(stat['icon'] as IconData, color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(stat['title'] as String, style: const TextStyle(fontSize: 14)),
                        const SizedBox(height: 5),
                        Text(stat['count'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
