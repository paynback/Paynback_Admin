import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pndb_admin/data/models/commission_merchant_model.dart';
import 'package:pndb_admin/utils/api_endpoints.dart';

class CommissionService {
  static Future<void> updateAllMerchantsCommission(int rate) async {
    final url = Uri.parse("${ApiConstants.baseUrl}/api/admin/update-all-merchants-commission");
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"value": rate}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update commission");
    }
  }

  static Future<void> updateSingleMerchantsCommission(int rate,String merchantId) async {
    final url = Uri.parse("${ApiConstants.baseUrl}/api/admin/update-merchant-commission");
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "value": rate,"merchant_id": merchantId
        }
        ),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update commission");
    }
  }

  static Future<List<CommissionMerchantModel>> fetchAllMerchants() async {
    final url = Uri.parse("${ApiConstants.baseUrl}/api/admin/get-all-merchants");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List merchants = body['merchants'];
      return merchants.map((e) => CommissionMerchantModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch merchants");
    }
  }
}
