import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pndb_admin/data/models/user_cashback_model.dart';
import 'package:pndb_admin/data/models/user_model.dart';
import 'package:pndb_admin/data/models/user_transaction_model.dart';
import 'package:pndb_admin/utils/api_endpoints.dart';

class UserService {
  
  final int _limit = 20;

  Future<List<UserModel>> fetchUsers({required int page}) async {
    // final String baseUrl = dotenv.env['BASE_URL'].toString();

    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/api/admin/get-all-users?page=$page&limit=$_limit'),
      headers: {'Content-Type': 'application/json','Accept': 'application/json',},
    );

    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<UserModel> users = (data['users'] as List)
          .map((json) => UserModel.fromJson(json))
          .toList();

      return users;
    } else {
      throw Exception("Failed to load users");
    }
  }

  Future<UserModel> fetchUserDetailsByUid(String uid) async {

    // final String baseUrl = dotenv.env['BASE_URL'].toString();
    final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/get-user-details/$uid');
    final response = await http.get(
      url
    );

    print("Status Code: ${response.statusCode}");
    print("Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // ✅ Extract the 'user' field from the response
      final userJson = data['user'];

      return UserModel.fromJson(userJson);
    } else {
      throw Exception('Failed to fetch user details');
    }
  }


  Future<void> blockOrUnblockUser({
    required String userId,
    required bool shouldBlock,
  }) async {

    // final String baseUrl = dotenv.env['BASE_URL'].toString();

    final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/block-unblock-user');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'action': shouldBlock ? 'block' : 'unblock',
      }),
    );

    print('Block/Unblock Response: ${response.statusCode} ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to ${shouldBlock ? 'block' : 'unblock'} user');
    }
  }

  Future<double> fetchUserWallet(String userId) async {
    // final String baseUrl = dotenv.env['BASE_URL'].toString();

    final url = Uri.parse('${ApiConstants.baseUrl}/api/admin/get-user-wallet/$userId');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coinsString = data['pointWallet']?['coins'] ?? '0';
      return double.tryParse(coinsString.toString()) ?? 0.0;
    } else {
      throw Exception('Wallet not created');
    }
  }

  Future<List<UserTransactionModel>> fetchTransactions({
    required String userId,
    required int page,
    required int limit,
  }) async {
    // final String baseUrl = dotenv.env['BASE_URL'].toString();
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/api/admin/get-user-transactions/$userId',
    ).replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List transactions = data['transactions'] ?? [];
      return transactions.map((e) => UserTransactionModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<List<UserCashbackModel>> fetchCashbacks({
    required String userId,
    required int page,
    required int limit,
  }) async {
    // final String baseUrl = dotenv.env['BASE_URL'].toString();
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/api/admin/get-user-rewards/$userId',
    ).replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List transactions = data['rewards'] ?? [];
      return transactions.map((e) => UserCashbackModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cashbacks');
    }
  }

}