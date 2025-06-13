import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show Uint8List, rootBundle;

class QrPdfPreviewPage extends StatelessWidget {
  final List<String> qrIds;

  const QrPdfPreviewPage({super.key, required this.qrIds});

  Future<Uint8List> _generatePdf(final PdfPageFormat format) async {
    final pdf = pw.Document();
    final imageBytes = await rootBundle.load('assets/images/template.jpg');
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());

    final blocksPerPage = 6;
    final blockWidth = 1181.0;
    final blockHeight = 1772.0;

    for (int i = 0; i < qrIds.length; i += blocksPerPage) {
      final chunk = qrIds.skip(i).take(blocksPerPage).toList();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a3,
          build: (context) {
            return pw.Wrap(
              spacing: 0,
              runSpacing: 0,
              children: chunk.map((qrId) {
                return pw.Container(
                  width: blockWidth,
                  height: blockHeight,
                  child: pw.Stack(
                    children: [
                      pw.Positioned.fill(
                        child: pw.Image(image, fit: pw.BoxFit.cover),
                      ),
                      pw.Center(
                        child: pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: qrId,
                          width: 300,
                          height: 300,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Code PDF Preview')),
      body: PdfPreview(
        maxPageWidth: 700,
        canChangeOrientation: false,
        canChangePageFormat: false,
        build: (format) => _generatePdf(format),
      ),
    );
  }
}
