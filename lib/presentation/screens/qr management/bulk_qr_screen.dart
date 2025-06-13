import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pndb_admin/presentation/screens/qr%20management/widgets/pdf_service.dart';
import 'package:pndb_admin/presentation/screens/qr%20management/widgets/qr_list_tab.dart';
import 'package:pndb_admin/presentation/screens/qr%20management/widgets/quantity_dialog.dart';
import 'package:pndb_admin/presentation/viewmodels/qr/assigned_qr/assigned_qr_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/qr/downloaded_qr/downloaded_qr_bloc.dart';
import 'package:pndb_admin/presentation/viewmodels/qr/qr%20managemenet/qr_management_bloc.dart';

class BulkQrManagementScreen extends StatefulWidget {
  const BulkQrManagementScreen({super.key});

  @override
  State<BulkQrManagementScreen> createState() => _BulkQrManagementScreenState();
}

class _BulkQrManagementScreenState extends State<BulkQrManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initial fetch
    context.read<QrManagementBloc>().add(FetchGeneratedQrCodes());

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;

      setState(() {
        _currentIndex = _tabController.index;
      });

      if (_currentIndex == 0) {
        context.read<QrManagementBloc>().add(FetchGeneratedQrCodes());
      } else if (_currentIndex == 1) {
        context.read<DownloadedQrBloc>().add(FetchDownloadedQrs());
      } else if (_currentIndex == 2) {
        context.read<AssignedQrBloc>().add(FetchAssignedQrCodes());
      }
    });
  }

  Future<void> _generateQrCodes(int count) async {
    context.read<QrManagementBloc>().add(GenerateQrs(count));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$count QR codes generated.')),
    );
  }

  Future<void> _downloadQrCodes(int count) async {
    final bloc = context.read<DownloadedQrBloc>();
    late final StreamSubscription subscription;

    subscription = bloc.stream.listen((state) async {
      if (state is DownloadedQrLoaded) {
        print("PdfService is being called with QR codes: ${state.qrCodes}");

        try {
          await PdfService.generatePdfWithQrs(state.qrCodes);
        } catch (e) {
          print("Error generating PDF: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to generate PDF')),
          );
        }

        await subscription.cancel(); // Now it's declared properly
      } else if (state is DownloadedQrError) {
        print("Error state: ${state.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download QR codes')),
        );
        await subscription.cancel();
      }
    });

    bloc.add(GenerateDownloadedQrs(count));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Downloading QR codes...')),
    );
  }
  // Future<void> _downloadQrCodes(int count) async {
  //   final bloc = context.read<DownloadedQrBloc>();
  //   late final StreamSubscription subscription;

  //   // Show loading dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => const Center(child: CircularProgressIndicator()),
  //   );

  //   subscription = bloc.stream.listen((state) async {
  //     if (state is DownloadedQrLoaded) {
  //       print("PdfService is being called with QR codes: ${state.qrCodes}");

  //       try {
  //         await PdfService.generatePdfWithQrs(state.qrCodes);
  //       } catch (e) {
  //         print("Error generating PDF: $e");
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Failed to generate PDF')),
  //         );
  //       } finally {
  //         Navigator.of(context).pop(); // Close loading dialog
  //       }

  //       await subscription.cancel();
  //     } else if (state is DownloadedQrError) {
  //       print("Error state: ${state.message}");

  //       Navigator.of(context).pop(); // Close loading dialog
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to download QR codes')),
  //       );

  //       await subscription.cancel();
  //     }
  //   });

  //   bloc.add(GenerateDownloadedQrs(count));

  //   // Optionally notify user
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Preparing QR codes...')),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bulk QR Manager")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    showQuantityDialog(
                      context: context,
                      title: 'How many QR codes to generate?',
                      onSubmit: _generateQrCodes,
                    );
                  },
                  icon: const Icon(Icons.qr_code),
                  label: const Text('Generate QR Codes'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    showQuantityDialog(
                      context: context,
                      title: 'How many QR codes to download?',
                      onSubmit: _downloadQrCodes,
                    );
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download QR Codes'),
                )

                // BlocListener<DownloadedQrBloc, DownloadedQrState>(
                //   listener: (context, state) async {
                //     if (state is DownloadedQrLoaded) {
                //       print(
                //           "PdfService is being called with QR codes: ${state.qrCodes}");

                //       await PdfService.generatePdfWithQrs(state.qrCodes);
                //     }
                //   },
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       showQuantityDialog(
                //         context: context,
                //         title: 'How many QR codes to download?',
                //         onSubmit: _downloadQrCodes,
                //       );
                //     },
                //     icon: const Icon(Icons.download),
                //     label: const Text('Download QR Codes'),
                //   ),
                // )
              ],
            ),
            const SizedBox(height: 24),
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: 'Generated QR'),
                Tab(text: 'Downloaded QR'),
                Tab(text: 'Assigned QR'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Generated QR
                  BlocBuilder<QrManagementBloc, QrManagementState>(
                    builder: (context, state) {
                      if (state is QrManagementLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is QrManagementLoaded) {
                        return QrListTab(
                          label: 'Generated',
                          qrCodes: state.qrCodes,
                        );
                      } else if (state is QrManagementError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      return const Center(child: Text('No data available.'));
                    },
                  ),

                  // Tab 2: Downloaded QR
                  BlocBuilder<DownloadedQrBloc, DownloadedQrState>(
                    builder: (context, state) {
                      if (state is DownloadedQrLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DownloadedQrLoaded) {
                        return QrListTab(
                            label: 'Downloaded', qrCodes: state.qrCodes);
                      } else if (state is DownloadedQrError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      return const Center(
                          child: Text('No downloaded QR codes available.'));
                    },
                  ),
                  // Tab 3: Assigned QR
                  BlocBuilder<AssignedQrBloc, AssignedQrState>(
                    builder: (context, state) {
                      if (state is AssignedQrLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AssignedQrLoaded) {
                        return QrListTab(
                          label: 'Assigned',
                          qrCodes: state.qrCodes,
                        );
                      } else if (state is AssignedQrError) {
                        return Center(child: Text('Error: ${state.message}'));
                      }
                      return const Center(child: Text('No data available.'));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
