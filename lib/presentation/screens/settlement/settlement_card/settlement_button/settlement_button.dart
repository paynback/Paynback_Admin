import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/settlement/settlement_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/submit_settlement/submit_settlement_bloc.dart';

class SettlementButton extends StatelessWidget {
  final String settlementId; // Add this to pass ID

  const SettlementButton({super.key, required this.settlementId});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                String? selectedStatus;
                TextEditingController remarkController =
                    TextEditingController();

                return BlocProvider(
                  create: (_) => SubmitSettlementBloc(),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return BlocListener<SubmitSettlementBloc,
                          SubmitSettlementState>(
                        listener: (context, state) {
                          if (state is SubmitSettlementSuccess) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content:
                                    Text("Settlement SETTLED successfully"),
                              ),
                            );
                            context.read<SettlementBloc>().add(FetchSettlements(status: "SETTLED",page: 1));
                          } else if (state is SubmitSettlementFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Settlement FAILED'),
                              ),
                            );
                          }
                        },
                        child: AlertDialog(
                          title: const Text("Confirm Settlement"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: "Settlement Status",
                                  border: OutlineInputBorder(),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: "SETTLED",
                                    child: Text("SETTLED"),
                                  ),
                                  DropdownMenuItem(
                                    value: "FAILED",
                                    child: Text("FAILED"),
                                  ),
                                ],
                                value: selectedStatus,
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              if (selectedStatus == "SETTLED")
                                TextFormField(
                                  controller: remarkController,
                                  decoration: const InputDecoration(
                                    labelText: "Enter UTR ID",
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 1,
                                ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("Cancel"),
                            ),
                            BlocBuilder<SubmitSettlementBloc,
                                SubmitSettlementState>(
                              builder: (context, state) {
                                final isLoading =
                                    state is SubmitSettlementLoading;

                                return ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () {
                                          if (selectedStatus == null) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                    "Please select a status"),
                                              ),
                                            );
                                          } else if (selectedStatus ==
                                                  "SETTLED" &&
                                              remarkController.text
                                                  .trim()
                                                  .isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.red,
                                                content:
                                                    Text("Please enter UTR ID"),
                                              ),
                                            );
                                          } else {
                                            log(selectedStatus.toString());
                                            context
                                                .read<SubmitSettlementBloc>()
                                                .add(
                                                  SubmitSettlement(
                                                    settlementId: settlementId,
                                                    status: selectedStatus!,
                                                    utr: remarkController.text
                                                        .trim(),
                                                  ),
                                                );
                                          }
                                        },
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Text("Update Settle Status"),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 4,
            shadowColor: Colors.teal.shade300,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.payment, size: 20),
              SizedBox(width: 8),
              Text(
                "Process Settlement",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
