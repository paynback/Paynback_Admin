// lib/screens/commission_management_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/commission/commission_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/update_all_commission/update_all_commission_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/update_single_commission/update_single_commission_bloc.dart';

class CommissionManagementScreen extends StatefulWidget {
  const CommissionManagementScreen({super.key});

  @override
  State<CommissionManagementScreen> createState() => _CommissionManagementScreenState();
}

class _CommissionManagementScreenState extends State<CommissionManagementScreen> {
  final TextEditingController _commissionController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  @override
  void dispose() {
    _commissionController.dispose();
    _rateController.dispose();
    super.dispose();
  }

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
            Row(
              children: [
                Text(
                  "Commission Rate",
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 60,
                  child: TextFormField(
                    controller: _commissionController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Rate",
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.indigo[700],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    final rate = int.tryParse(_commissionController.text.trim());
                    if (rate != null && rate>=0 && rate<=100) {
                      context.read<UpdateAllCommissionBloc>().add(UpdateCommissionRate(rate));
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  child: Text("Update", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 10),
                BlocConsumer<UpdateAllCommissionBloc, UpdateAllCommissionState>(
                  listener: (context, state) {
                    if (state is UpdateSuccess) {
                      context.read<CommissionBloc>().add(FetchMerchants());
                    }
                  },
                  builder: (context, state) {
                    if (state is UpdateLoading) {
                      return SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    } else if (state is UpdateSuccess) {
                      return Text(
                        "✅ Commission set to ${_commissionController.text.trim()}%",
                        style: TextStyle(color: Colors.green),
                      );
                    } else if (state is UpdateFailure) {
                      return Text("❌", style: TextStyle(color: Colors.red));
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<CommissionBloc, CommissionState>(
                builder: (context, state) {
                  if (state is CommissionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CommissionLoaded) {
                    final merchants = state.merchants;
    
                    return ListView.builder(
                      itemCount: merchants.length,
                      itemBuilder: (context, index) {
                        final merchant = merchants[index];
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
                            title: Text(merchant.shopName),
                            subtitle: Text("Commission Rate: ${merchant.commission}%"),
                            trailing: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) {
                                    return BlocProvider(
                                      create: (_) => UpdateSingleCommissionBloc(),
                                      child: BlocConsumer<UpdateSingleCommissionBloc, UpdateSingleCommissionState>(
                                        listener: (context, state) {
                                          if (state is UpdateSingleCommissionSuccess) {
                                            Navigator.pop(dialogContext); // Close dialog on success
                                            // Optional: Refresh data
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Commission updated successfully!")),
                                            );
                                            context.read<CommissionBloc>().add(FetchMerchants());
                                          } else if (state is UpdateSingleCommissionFailure) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text("Error: ${state.error}")),
                                            );
                                          }
                                        },
                                        builder: (context, state) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            title: Text("Change the commission rate of ${merchant.shopName}"),
                                            content: TextFormField(
                                              controller: _rateController,
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(
                                                labelText: "Commission Rate (%)",
                                                hintText: "Enter new rate",
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(dialogContext),
                                                child: const Text("Cancel"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  final newRate = int.tryParse(_rateController.text.trim());
                                                  if (newRate != null) {
                                                    context.read<UpdateSingleCommissionBloc>().add(
                                                          UpdateSingleCommissionRate(newRate,merchant.merchantId),
                                                        );
                                                  }
                                                },
                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                                                child: state is UpdateSingleCommissionLoading
                                                    ? const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                                      )
                                                    : const Text("Confirm", style: TextStyle(color: Colors.white)),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text(
                                "Update",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is CommissionError) {
                    return Center(child: Text("Error: ${state.error}"));
                  }
                  return SizedBox.shrink(); // For initial state
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
