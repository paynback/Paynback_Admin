import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pndb_admin/data/models/bulk_qr_model.dart';
import 'package:printing/printing.dart';

// import 'dart:html' as html;
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:http/http.dart' as http;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pndb_admin/data/models/bulk_qr_model.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart';
// import 'package:pdf/widgets.dart' as pdfWidgets;

// class PdfService {
//   static Future<pw.MemoryImage> _networkImage(String url) async {
//     final response = await http.get(Uri.parse(url));
//     if (response.statusCode == 200) {
//       return pw.MemoryImage(response.bodyBytes);
//     } else {
//       throw Exception("Failed to load image from $url");
//     }
//   }

//   static Future<pw.ImageProvider> _imageFromAsset(String path) async {
//     final bytes = await rootBundle.load(path);
//     return pw.MemoryImage(bytes.buffer.asUint8List());
//   }

//   static Future<void> generatePdfWithQrs(List<QrCodeModel> qrCodes) async {
//     final doc = pw.Document();
//     final logo = await _imageFromAsset('asset/images/PayNback_Logo.png');
//     final yammyImage = await _imageFromAsset('asset/images/yammy.png');
//     final font = await PdfGoogleFonts.notoSansRegular();
//     final boldFont = await PdfGoogleFonts.notoSansBold();

//     final qrPairs = await Future.wait(
//       qrCodes.map((qrModel) async {
//         try {
//           final image = await _networkImage(qrModel.qrCode);
//           return MapEntry(qrModel, image);
//         } catch (e) {
//           print('❌ Failed to load image for ${qrModel.qrId}: $e');
//           return null;
//         }
//       }),
//     );

//     final validQrPairs =
//         qrPairs.whereType<MapEntry<QrCodeModel, pw.MemoryImage>>().toList();

//     const int itemsPerPage = 9;
//     final int totalPages = (validQrPairs.length / itemsPerPage).ceil();
//     final double itemWidth = PdfPageFormat.a3.width / 3;
//     final double itemHeight = PdfPageFormat.a3.height / 3;

//     for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
//       doc.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a3,
//           margin: pw.EdgeInsets.zero,
//           build: (context) {
//             return pw.Column(
//               children: List.generate(3, (row) {
//                 return pw.Row(
//                   children: List.generate(3, (col) {
//                     final index = pageIndex * itemsPerPage + row * 3 + col;
//                     if (index >= validQrPairs.length) return pw.SizedBox();

//                     final entry = validQrPairs[index];
//                     final qrModel = entry.key;
//                     final qrImage = entry.value;

//                     return pw.Container(
//                       width: itemWidth,
//                       height: itemHeight,
//                       padding: const pw.EdgeInsets.all(8),
//                       child: pw.Container(
//                         decoration: pw.BoxDecoration(
//                           color: PdfColors.white,
//                           border: pw.Border.all(
//                             color: PdfColors.blue700,
//                             width: 3,
//                           ),
//                           borderRadius: pw.BorderRadius.circular(12),
//                         ),
//                         padding: const pw.EdgeInsets.all(16),
//                         child: pw.Column(
//                           mainAxisAlignment: pw.MainAxisAlignment.center,
//                           children: [
//                             pw.Container(
//                               alignment: pw.Alignment.center,
//                               child: pw.Container(
//                                 width: 120,
//                                 child: pw.Image(logo, fit: pw.BoxFit.contain),
//                               ),
//                             ),
//                             pw.Expanded(
//                               child: pw.Row(
//                                 mainAxisAlignment:
//                                     pw.MainAxisAlignment.spaceBetween,
//                                 crossAxisAlignment:
//                                     pw.CrossAxisAlignment.center,
//                                 children: [
//                                   pw.Column(
//                                     mainAxisAlignment:
//                                         pw.MainAxisAlignment.center,
//                                     children: [
//                                       pw.Container(
//                                         width: 140,
//                                         height: 140,
//                                         child: pw.Image(qrImage,
//                                             fit: pw.BoxFit.contain),
//                                       ),
//                                       pw.SizedBox(height: 12),
//                                       pw.Text(
//                                         qrModel.qrId,
//                                         style: pw.TextStyle(
//                                           fontSize: 10,
//                                           font: boldFont,
//                                           color: PdfColors.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   pw.Container(
//                                     height: 180,
//                                     child: pw.Image(yammyImage,
//                                         fit: pw.BoxFit.contain),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             pw.Column(
//                               children: [
//                                 pw.Text(
//                                   'Scan To Pay',
//                                   style: pw.TextStyle(
//                                     fontSize: 20,
//                                     font: boldFont,
//                                     color: PdfColors.black,
//                                     fontStyle: pw.FontStyle.italic,
//                                   ),
//                                 ),
//                                 pw.SizedBox(height: 8),
//                                 pw.Text(
//                                   'www.paynback.in',
//                                   style: pw.TextStyle(
//                                     fontSize: 12,
//                                     font: boldFont,
//                                     color: PdfColors.black,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }),
//                 );
//               }),
//             );
//           },
//         ),
//       );
//     }

//     /// Save and download as file
//     final bytes = await doc.save();
//     final blob = html.Blob([bytes]);
//     final url = html.Url.createObjectUrlFromBlob(blob);
//     final anchor = html.AnchorElement(href: url)
//       ..setAttribute("download", "QR_Codes.pdf")
//       ..click();
//     html.Url.revokeObjectUrl(url);
//   }
// }

class PdfService {
  static Future<pw.MemoryImage> _networkImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return pw.MemoryImage(response.bodyBytes);
    } else {
      throw Exception("Failed to load image from $url");
    }
  }

  static Future<pw.ImageProvider> _imageFromAsset(String path) async {
    final bytes = await rootBundle.load(path);
    return pw.MemoryImage(bytes.buffer.asUint8List());
  }

  // Updated method to match the reference design
  static Future<void> generatePdfWithQrs(List<QrCodeModel> qrCodes) async {
    final doc = pw.Document();
    final logo = await _imageFromAsset('asset/images/PayNback_Logo.png');
    final yammyImage = await _imageFromAsset('asset/images/yammy.png');
    // final font = await PdfGoogleFonts.notoSansRegular();
    final boldFont = await PdfGoogleFonts.notoSansBold();

    /// Pair each QrCodeModel with its downloaded image
    final qrPairs = await Future.wait(
      qrCodes.map((qrModel) async {
        try {
          final image = await _networkImage(qrModel.qrCode);
          // Store the complete QrCodeModel with its image
          return MapEntry(qrModel, image);
        } catch (e) {
          print('❌ Failed to load image for ${qrModel.qrId}: $e');
          return null;
        }
      }),
    );

    /// Remove any nulls due to failures - preserve the QrCodeModel pairing
    final validQrPairs =
        qrPairs.whereType<MapEntry<QrCodeModel, pw.MemoryImage>>().toList();

    print(
        '✅ Successfully loaded ${validQrPairs.length} QR code images out of ${qrCodes.length}');

    const int itemsPerPage = 9;
    final int totalPages = (validQrPairs.length / itemsPerPage).ceil();
    final double itemWidth = PdfPageFormat.a3.width / 3;
    final double itemHeight = PdfPageFormat.a3.height / 3;

    for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a3,
          margin: pw.EdgeInsets.zero,
          build: (context) {
            return pw.Column(
              children: List.generate(3, (row) {
                return pw.Row(
                  children: List.generate(3, (col) {
                    final index = pageIndex * itemsPerPage + row * 3 + col;
                    if (index >= validQrPairs.length) return pw.SizedBox();

                    final entry = validQrPairs[index];
                    final qrModel = entry.key; // Complete QrCodeModel
                    final qrImage = entry.value; // Corresponding image

                    return pw.Container(
                      width: itemWidth,
                      height: itemHeight,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Container(
                        decoration: pw.BoxDecoration(
                          color: PdfColors.white,
                          border: pw.Border.all(
                            color: PdfColors.blue700,
                            width: 3,
                          ),
                          borderRadius: pw.BorderRadius.circular(12),
                        ),
                        padding: const pw.EdgeInsets.all(16),
                        child: pw.Column(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            // Top section - Logo
                            pw.Container(
                              alignment: pw.Alignment.center,
                              child: pw.Container(
                                width: 120,
                                child: pw.Image(logo, fit: pw.BoxFit.contain),
                              ),
                            ),

                            // Middle section - QR Code and Mascot side by side
                            pw.Expanded(
                              child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  // Left: QR Code
                                  pw.Column(
                                    mainAxisAlignment:
                                        pw.MainAxisAlignment.center,
                                    children: [
                                      // QR Code
                                      pw.Container(
                                        width: 140,
                                        height: 140,
                                        child: pw.Image(qrImage,
                                            fit: pw.BoxFit.contain),
                                      ),
                                      pw.SizedBox(height: 12),
                                      // QR ID
                                      pw.Text(
                                        qrModel.qrId,
                                        style: pw.TextStyle(
                                          fontSize: 10,
                                          font: boldFont,
                                          color: PdfColors.black,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Right: Mascot Character
                                  pw.Container(
                                    height: 180,
                                    child: pw.Image(yammyImage,
                                        fit: pw.BoxFit.contain),
                                  ),
                                ],
                              ),
                            ),

                            // Bottom section - Scan to Pay text and website
                            pw.Column(
                              children: [
                                // Stylized "Scan To Pay" text
                                pw.Text(
                                  'Scan To Pay',
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                    font: boldFont,
                                    color: PdfColors.black,
                                    fontStyle: pw.FontStyle.italic,
                                  ),
                                ),
                                pw.SizedBox(height: 8),
                                // Website and social media icons row

                                pw.Text(
                                  'www.paynback.in',
                                  style: pw.TextStyle(
                                    fontSize: 12,
                                    font: boldFont,
                                    color: PdfColors.black,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }),
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (_) => doc.save(),
      name: 'QR_Codes.pdf',
    );
  }
}
