import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/data/services/user_service.dart';
import 'package:pndb_admin/presentation/viewmodels/user_cashback/user_cashback_bloc.dart';

class CashbackHistoryScreen extends StatelessWidget {
  final String userId;

  const CashbackHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserCashbackBloc(userService: UserService())
        ..add(FetchCashback(userId: userId, page: 1, limit: 20)),
      child: Scaffold(
        appBar: AppBar(title: const Text("Cashback History")),
        body: BlocBuilder<UserCashbackBloc, UserCashbackState>(
          builder: (context, state) {
            if (state is CashbackLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CashbackLoaded) {
              if (state.transactions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.money_off,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No cashback rewards found",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "User's cashback rewards will appear here once earned.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                      state.hasMore) {
                    context.read<UserCashbackBloc>().fetchNext(userId);
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: state.transactions.length,
                  itemBuilder: (_, index) {
                    final reward = state.transactions[index];
                    return ListTile(
                      leading: const Icon(Icons.card_giftcard, color: Colors.orange),
                      title: Text("₹${reward.coins} Cashback"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Type: ${reward.type}"),
                          Text("Transaction ID: ${reward.transactionId}"),
                          Text("Date: ${reward.createdAt.toLocal()}"),
                        ],
                      ),
                      trailing: reward.refUser != null
                          ? const Icon(Icons.person_outline)
                          : null,
                    );
                  },
                ),
              );
            } else if (state is CashbackError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
