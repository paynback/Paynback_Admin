import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/data/services/user_service.dart';
import 'package:pndb_admin/presentation/viewmodels/user_transaction/user_transaction_bloc.dart';

class TransactionHistoryScreen extends StatelessWidget {
  final String userId; 

  const TransactionHistoryScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserTransactionBloc(userService: UserService())
        ..add(FetchTransactions(userId: userId, page: 1, limit: 20)),
      child: Scaffold(
        appBar: AppBar(title: Text("Transaction History")),
        body: BlocBuilder<UserTransactionBloc, UserTransactionState>(
          builder: (context, state) {
            if (state is TransactionLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TransactionLoaded) {
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
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "No transactions found",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Users trasactions will appear here once they make a payment",
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
                    context.read<UserTransactionBloc>().fetchNext(userId);
                  }
                  return false;
                },
                child: ListView.builder(
                  itemCount: state.transactions.length,
                  itemBuilder: (_, index) {
                    final txn = state.transactions[index]; // txn is of type TransactionModel
                    return ListTile(
                      leading: Icon(
                        txn.status == 'SUCCESS' ? Icons.check_circle : Icons.error,
                        color: txn.status == 'SUCCESS' ? Colors.green : Colors.red,
                      ),
                      title: Text("₹${txn.amount}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Type: ${txn.type}"),
                          Text("Status: ${txn.status}"),
                          Text("Date: ${txn.createdAt.toLocal()}"),
                        ],
                      ),
                      trailing: Text(txn.transactionId),
                    );
                  },
                ),
              );
            } else if (state is TransactionError) {
              return Center(child: Text(state.message));
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}