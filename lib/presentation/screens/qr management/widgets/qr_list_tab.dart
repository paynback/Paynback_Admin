import 'package:flutter/material.dart';
import 'package:pndb_admin/data/models/bulk_qr_model.dart';
import 'package:pndb_admin/utils/constants.dart';

class QrListTab extends StatelessWidget {
  final String label;
  final List<QrCodeModel>? qrCodes;

  const QrListTab({super.key, required this.label, this.qrCodes});

  @override
  Widget build(BuildContext context) {
    if (qrCodes == null) {
      return const Center(child: Text("No data available."));
    }

    if (qrCodes!.isEmpty) {
      return Center(child: Text("No $label QR Codes"));
    }

    return ListView.separated(
      itemCount: qrCodes!.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final qr = qrCodes![index];
        return ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
            backgroundColor: pBlue,
            foregroundColor: pWhite,
          ),
          title: Text('QR ID: ${qr.qrId}'),
          // subtitle: Text('Downloaded: ${qr.isDownloaded}, Assigned: ${qr.isAssigned}'),
          // trailing: Image.network(qr.qrCode, height: 40), 
        );
      },
    );
  }
}
