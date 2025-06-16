import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/data/services/dashboard_service.dart';
import 'package:pndb_admin/presentation/viewmodels/dashboard/dashboard_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardBloc(DashboardService())..add(FetchDashboardData()),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard Overview', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<DashboardBloc, DashboardState>(
                builder: (context, state) {
                  if (state is DashboardLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DashboardLoaded) {
                    print('DashboardLoaded state');
                    final stats = [
                      {'title': 'Total Users', 'count': state.stats['Total Users'], 'icon': Icons.people, 'color': Colors.blue},
                      {'title': 'Total Merchants', 'count': state.stats['Total Merchants'], 'icon': Icons.store, 'color': Colors.deepPurple},
                      {'title': 'Total Cashback Given', 'count': state.stats['Cashback Given'], 'icon': Icons.card_giftcard, 'color': Colors.green},
                      {'title': 'Total Commission Earned', 'count': state.stats['Commission Earned'], 'icon': Icons.percent, 'color': Colors.orange},
                      {'title': 'Total Sales', 'count': state.stats['Sales'], 'icon': Icons.shopping_cart, 'color': Colors.pinkAccent},
                    ];

                    return GridView.builder(
                      itemCount: stats.length,
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
                            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
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
                                  Text((stat['count'] as String? ?? '0'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is DashboardError) {
                    return Center(child: Text('Error: ${state.message}'));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}