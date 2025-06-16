import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pndb_admin/utils/api_endpoints.dart';

class DashboardService {
  Future<String> fetchCount(String endpoint) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/api/admin$endpoint');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Return different values depending on endpoint
      switch (endpoint) {
        case '/total-user-count':
          return data['totalUserCount'].toString();
        case '/total-cashback-count':
          return data['totalCashBackCount'].toString();
        case '/total-merchant-count':
          return data['totalMerchantsCount'].toString();
        case '/total-sales-count':
          return data['totalSalesCount'].toString();
        case '/total-commission-count':
          return data['totalMerchantsCommissionCount'].toString();
        default:
          throw Exception('Unsupported endpoint: $endpoint');
      }
    } else {
      throw Exception('Failed to load data for $endpoint');
    }
  }
}