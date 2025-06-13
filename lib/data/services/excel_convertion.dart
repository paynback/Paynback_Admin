import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:pndb_admin/data/models/settlement_model.dart';

class ExcelConvertion {
  
  Future<Uint8List?> exportToExcel(List<SettlementModel> settlements) async {
    try {
      print("Starting Excel export...");
      
      // Create Excel workbook
      var excel = Excel.createExcel();
      
      // Remove default sheet and create a new one
      excel.delete('Sheet1');
      Sheet sheetObject = excel['Settlements'];
      
      // Define headers
      List<String> headers = [
        'Settlement ID',
        'Merchant ID', 
        'Amount',
        'Total Amount',
        'Merchant Fee',
        'GST',
        'Date',
        'Status'
      ];
      
      // Add headers to first row
      for (int i = 0; i < headers.length; i++) {
        var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
        cell.value = TextCellValue(headers[i]);
        
        // Style the header row
        cell.cellStyle = CellStyle(
          bold: true,
          horizontalAlign: HorizontalAlign.Center,
          verticalAlign: VerticalAlign.Center,
        );
      }
      
      // Add data rows
      for (int rowIndex = 0; rowIndex < settlements.length; rowIndex++) {
        final settlement = settlements[rowIndex];
        
        List<String> rowData = [
          settlement.settlementId,
          settlement.merchantId,
          settlement.amount,
          settlement.totalAmount,
          settlement.merchantFee,
          settlement.gst,
          settlement.date,
          settlement.status,
        ];
        
        for (int colIndex = 0; colIndex < rowData.length; colIndex++) {
          var cell = sheetObject.cell(CellIndex.indexByColumnRow(
            columnIndex: colIndex, 
            rowIndex: rowIndex + 1
          ));
          cell.value = TextCellValue(rowData[colIndex]);
        }
      }
      
      // Set column widths
      for (int i = 0; i < headers.length; i++) {
        sheetObject.setColumnWidth(i, 18.0);
      }
      
      // Encode the Excel file
      var bytes = excel.encode();
      if (bytes != null) {
        print("✅ Excel file generated successfully!");
        print("📊 Records exported: ${settlements.length}");
        
        // Convert to Uint8List for better handling
        Uint8List uint8bytes = Uint8List.fromList(bytes);
        
        // If running on web, trigger download
        if (kIsWeb) {
          await _triggerWebDownload(uint8bytes);
        }
        
        return uint8bytes;
      } else {
        throw Exception("Failed to encode Excel file");
      }
      
    } catch (e) {
      print("❌ Error exporting to Excel: $e");
      rethrow;
    }
  }
  
  Future<void> _triggerWebDownload(Uint8List bytes) async {
    try {
      // Generate filename with current timestamp
      final fileName = 'settlements_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      
      // Create a blob from the bytes
      final blob = web.Blob([bytes.toJS].toJS, 
        web.BlobPropertyBag(type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'));
      
      // Create a URL for the blob
      final url = web.URL.createObjectURL(blob);
      
      // Create an anchor element and trigger download
      final anchor = web.HTMLAnchorElement();
      anchor.href = url;
      anchor.download = fileName;
      anchor.style.display = 'none';
      
      // Add to DOM, click, and remove
      web.document.body!.appendChild(anchor);
      anchor.click();
      web.document.body!.removeChild(anchor);
      
      // Clean up the URL
      web.URL.revokeObjectURL(url);
      
      print("📥 Excel file downloaded successfully: $fileName");
      print("💾 File size: ${bytes.length} bytes");
      
    } catch (e) {
      print("❌ Error triggering web download: $e");
      rethrow;
    }
  }
}

// Extension to handle the bytes if needed
extension ExcelFileHandler on Uint8List {
  void saveAsFile(String fileName) {
    // This method can be implemented differently based on platform
    print("📁 File ready to save as: $fileName");
    print("💾 File size: ${this.length} bytes");
  }
}