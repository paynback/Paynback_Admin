
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/data/services/excel_convertion.dart';
import 'package:pndb_admin/data/services/merchent_settlement.dart';
import 'package:pndb_admin/presentation/screens/settlement/settlement_card/settlement_card.dart';
import 'package:pndb_admin/presentation/viewmodels/settlement/settlement_bloc.dart';
import 'package:pndb_admin/utils/constants.dart';

class SettlementManagementScreen extends StatefulWidget {
  const SettlementManagementScreen({super.key});

  @override
  State<SettlementManagementScreen> createState() => _SettlementManagementScreenState();
}

class _SettlementManagementScreenState extends State<SettlementManagementScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final SettlementBloc _bloc = SettlementBloc(MerchantSettlement());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _bloc.add(FetchSettlements(status: 'PENDING'));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        final currentState = _bloc.state;
        if (currentState is SettlementLoaded && currentState.hasMore) {
          _bloc.add(FetchSettlements(
            status: currentState.status,
            page: currentState.currentPage + 1,
          ));
        }
      }
    });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final selectedStatus = statuses[_tabController.index];
      _bloc.add(FetchSettlements(status: selectedStatus, page: 1));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final statuses = ['PENDING', 'SETTLED', 'FAILED'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade50,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Settlement Management", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TabBar(
                controller: _tabController,
                tabs: statuses.map((s) => Tab(text: s,)).toList(),
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.black54,
                indicatorColor: Colors.teal,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<SettlementBloc, SettlementState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state is SettlementLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is SettlementLoaded) {
                      if (state.settlements.isEmpty) {
                        return const Center(child: Text("No data available"));
                      }
                      
                      return Column(
                        children: [
                          if (state.status == 'PENDING') // ✅ Show button only for PENDING
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      print("Starting export...");
                                      
                                      // Call the export function
                                      Uint8List? excelBytes = await ExcelConvertion().exportToExcel(state.settlements);
                                      
                                      if (excelBytes != null) {
                                        // Show success message
                                        if (mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(Icons.check_circle, color: Colors.white),
                                                  SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text('Excel file generated successfully! ${excelBytes.length} bytes'),
                                                  ),
                                                ],
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: Duration(seconds: 4),
                                            ),
                                          );
                                        }
                                        
                                        print("✅ Export completed successfully!");
                                        print("📊 Total records: ${state.settlements.length}");
                                        print("💾 File size: ${excelBytes.length} bytes");
                                        
                                      } else {
                                        throw Exception("Failed to generate Excel file");
                                      }
                                      
                                    } catch (e) {
                                      print("❌ Export failed: $e");
                                      
                                      // Show error message
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                Icon(Icons.error, color: Colors.white),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text('Export failed: ${e.toString()}'),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 4),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: const Text("Convert to Excel Sheet",style: TextStyle(color: pWhite),),
                                ),
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: state.settlements.length + (state.hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index >= state.settlements.length) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                final settlement = state.settlements[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SettlementCard(settlement: settlement),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (state is SettlementError) {
                      return Center(child: Text(state.message));
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}