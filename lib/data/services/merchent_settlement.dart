import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pndb_admin/data/models/settlement_model.dart';
import 'package:pndb_admin/utils/api_endpoints.dart';

class MerchantSettlement {

  Future<Map<String, dynamic>> fetchSettlements({
    required int page,
    required int limit,
    required DateTime date,
    required String status,
  }) async {
    
    final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/get-settlement-list?page=$page&limit=$limit&date=2025-06-02&status=$status');
    final response = await http.get(
      url
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<SettlementModel> settlements = (data['merchants'] as List)
          .map((e) => SettlementModel.fromJson(e))
          .toList();

      return {
        'settlements': settlements,
        'hasMore': settlements.length == limit,
      };
    } else {
      throw Exception("Failed to load settlements");
    }
  }

  Future<bool> setSettlementStatus({
    required String settlementId,
    required String status,
    required String utr,
  }) async {
    final String url = "${ApiConstants.baseUrl}/api/admin/set-settlement-status";

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "settlement_id": settlementId,
          "status": status,
          "utr": utr,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Failed: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    }
  }

}
