import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pndb_admin/data/models/channel_partner_model.dart';
import 'package:pndb_admin/data/models/merchant_model.dart';
import 'package:pndb_admin/utils/api_endpoints.dart';

class ChannelPartnerService {

  Future<bool> create({
    required String name,
    required String phone,
    required String idProofFront,
    required String idProofBack,
    required String district,
    required String email,
    required String? profilePicture,
  }) async {
    final url = Uri.parse(
        '${ApiConstants.baseUrl}/api/admin/create-channel-partner');

    final body = jsonEncode({
      "name": name,
      "phone": phone,
      "idProofFront": idProofFront,
      "idProofBack": idProofBack,
      "profilePicture": profilePicture,
      "district": district,
      "email": email
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to create channel partner: ${response.body}');
    }
  }


  Future<List<ChannelPartnerModel>> fetchChannelPartners() async {
    final response = await http.get(Uri.parse('${ApiConstants.baseUrl}/api/admin/get-all-channel-partners'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> partnersJson = data['channelPartners'];
      return partnersJson
          .map((json) => ChannelPartnerModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load channel partners');
    }
  }

  Future<bool> toggleBlockStatus(String id, bool isBlocked) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/api/admin/block-unblock-channel-partner',
    );

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'channel_partner_id': id,
        'isBlocked': isBlocked,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Failed: ${response.statusCode}');
      return false;
    }
  }

  Future<List<Merchant>> fetchMerchants(String channelPartnerId) async {
    
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/api/admin/get-channel-partner-merchants/$channelPartnerId',
    );

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},      
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List<dynamic> merchantsJson = data['merchants'] ?? [];

      return merchantsJson
          .map((merchantJson) => Merchant.fromJson(merchantJson))
          .toList();
    } else {
      throw Exception('Failed to fetch merchants');
    }
  }

  Future<String> regeneratePassword(String channelPartnerId) async {
    final url = Uri.parse(
      '${ApiConstants.baseUrl}/api/admin/regenerate-channel-partner-password',
    );

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'channel_partner_id': channelPartnerId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['newPassword'] ?? 'Password regenerated';
    } else {
      throw Exception('Failed to regenerate password');
    }
  }

}