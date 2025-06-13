import 'dart:convert';
import 'package:pndb_admin/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginService {

  Future<bool> login(String email, String password) async {
    try {
      print('Attempting login...');
      print('Email: $email');
      print('Password: $password');

      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/api/admin/admin-auth'),
        headers: {'Content-Type': 'application/json','Accept': 'application/json',},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Login successful, response data: $data');

        // ✅ Save login state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        print('🔒 Saved isLoggedIn = true');

        return true;
      } else {
        print('Login failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Exception caught during login: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    print('✅ isLoggedIn removed: ${!prefs.containsKey('isLoggedIn')}');

    // Optional: Print entire prefs
    print('SharedPreferences after logout: ${prefs.getKeys()}');
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }
}
