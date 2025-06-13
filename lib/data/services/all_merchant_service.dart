import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pndb_admin/data/models/merchant_model.dart';
import 'package:pndb_admin/utils/api_endpoints.dart';

class MerchantService {
  // final String baseUrl = 'https://chairs-configuration-holder-reg.trycloudflare.com';
      // final String baseUrl = dotenv.env['BASE_URL'].toString();


  // Fetch limited details of all merchants with pagination
  Future<List<Merchant>> fetchMerchants({int page = 1, int limit = 10}) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}/api/admin/get-all-merchants?page=$page&limit=$limit');
    final response = await http.get(url);

    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final merchantsJson = jsonData['merchants'] as List;

      return merchantsJson.map((json) => Merchant.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch merchant list: ${response.body}');
    }
  }

  // Fetch full details of a specific merchant by ID
  Future<Merchant> fetchMerchantDetails(String merchantId) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}/api/admin/get-merchant-details/$merchantId');
    final response = await http.get(url);

    print('Response Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Merchant.fromJson(jsonData['merchant']);
    } else {
      throw Exception('Failed to fetch merchant details: ${response.body}');
    }
  }

  Future<bool> verifyMerchant(String merchantId) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}/api/admin/verify-merchant');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'merchant_id': merchantId}),
    );

    if (response.statusCode == 200) {
      // You may parse and check the body if needed
      return true;
    } else {
      return false;
    }
  }
}
