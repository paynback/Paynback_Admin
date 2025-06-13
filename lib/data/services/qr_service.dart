import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pndb_admin/data/models/bulk_qr_model.dart';
import 'package:pndb_admin/presentation/screens/qr%20management/widgets/pdf_service.dart';
import 'package:pndb_admin/utils/api_endpoints.dart';

class QrService {

  // Fetch QR codes based on status
  static Future<List<QrCodeModel>> fetchGeneratedQrs() async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/api/admin/get-bulk-qrcodes?isDownloaded=false&isAssigned=false'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // debugPrint("API Response: $data");

      // Ensure the key is "qrCode", not "qrcodes"
      if (data is Map && data['qrCode'] is List) {
        final List<dynamic> qrList = data['qrCode'];
        return qrList.map((json) => QrCodeModel.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected data format: "qrCode" is not a List');
      }
    } else {
      throw Exception('Failed to fetch generated QR codes');
    }
  }

  // POST: Trigger download generation
  // Updated service method with proper error handling
  static Future<void> generateAndShowPdfWithDownloadedQrs(int count) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiConstants.baseUrl}/api/admin/download-qrcodes"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"limit": count}),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to generate downloaded QR codes. Status: ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      List<dynamic> qrCodeJsonList;

      if (decoded is Map<String, dynamic> && decoded.containsKey("qrCodes")) {
        qrCodeJsonList = decoded["qrCodes"];
      } else {
        throw Exception('Unexpected response format: ${response.body}');
      }

      // Convert JSON to List<QrCodeModel> with proper field mapping
      final qrCodes = qrCodeJsonList.map((json) {
        return QrCodeModel(
          qrId: json['qr_id'] ?? '', // API uses 'qr_id'
          qrCode: json['qrCode'] ?? '',
          merchantId: json['merchantId'] ?? '',
          isAssigned: json['isAssigned'] ?? false,
          isDownloaded: json['isDownloaded'] ?? false,
          createdAt: json['createdAt'] ?? '',
          updatedAt: json['updatedAt'] ?? '',
        );
      }).toList();

      print('✅ Parsed ${qrCodes.length} QR code models');

      // Log the QR codes for debugging
      for (int i = 0; i < qrCodes.length; i++) {
        print(
            'QR $i: ID=${qrCodes[i].qrId}, URL=${qrCodes[i].qrCode.substring(0, 50)}...');
      }

      // Immediately generate and show PDF with these QR codes
      await PdfService.generatePdfWithQrs(qrCodes);
    } catch (e) {
      print('❌ Error in generateAndShowPdfWithDownloadedQrs: $e');
      rethrow;
    }
  }

  // GET: Fetch downloaded QR codes
  // Corrected GET: Fetch downloaded QR codes
  static Future<List<QrCodeModel>> fetchDownloadedQrs() async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}/api/admin/get-bulk-qrcodes?isDownloaded=true&isAssigned=false');

    final response = await http.get(url);
    // debugPrint("Downloaded QR response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint("Downloaded API Response: $data");

      // Ensure the key is "qrCode", not "qrcodes"
      if (data is Map && data['qrCode'] is List) {
        final List<dynamic> qrList = data['qrCode'];

        return qrList.map((json) => QrCodeModel.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected data format: "qrCode" is not a List');
      }
    } else {
      throw Exception("Failed to load downloaded QRs");
    }
  }

  // Assign QR codes
  static Future<List<QrCodeModel>> fetchAssignedQrs() async {
    final response = await http.get(
      Uri.parse(
          '${ApiConstants.baseUrl}/api/admin/get-bulk-qrcodes?isDownloaded=true&isAssigned=true'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint("API Response: $data");

      // Ensure the key is "qrCode", not "qrcodes"
      if (data is Map && data['qrCode'] is List) {
        final List<dynamic> qrList = data['qrCode'];
        return qrList.map((json) => QrCodeModel.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected data format: "qrCode" is not a List');
      }
    } else {
      throw Exception('Failed to fetch Assigned QR codes');
    }
  }

  // Generate new QR codes
  static Future<void> generateQrs(int count) async {
    final response = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/api/admin/generate-qrcodes"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"limit": count}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to generate QR codes');
    }
  }
}
