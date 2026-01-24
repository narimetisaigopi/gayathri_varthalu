import 'dart:convert';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:gayathri_varthalu/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class TokenService {
  /// Generates a random numeric token of [length] digits.
  static String generateRandomToken({int length = 10}) {
    final rand = Random();
    return List.generate(length, (_) => rand.nextInt(10).toString()).join();
  }

  /// Gets the device GSM ID (Android ID for Android, identifierForVendor for iOS)
  static Future<String> getDeviceGsmId() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    } catch (_) {
      // Not Android, try iOS
      try {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? '';
      } catch (_) {
        return '';
      }
    }
  }

  /// Sends the token registration request to the API.
  static Future<http.Response> registerToken() async {
    final mobileId = await getDeviceGsmId();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final body = jsonEncode({
      'mobile_id': mobileId,
      'token': fcmToken ?? '',
    });
    final response = await http.post(
      Uri.parse(ApiConstants.paTokenURL),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print('===== Register Token API Response =====');
    print('URL: ${ApiConstants.paTokenURL}');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('======================================');
    return response;
  }

  /// Fetches the API and returns the decoded response (with weburl and liveurl).
  static Future<Map<String, dynamic>?> fetchUrls() async {
    final mobileId = await getDeviceGsmId();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    final body = jsonEncode({
      'mobile_id': mobileId,
      'token': fcmToken ?? '',
    });
    final response = await http.post(
      Uri.parse(ApiConstants.paTokenURL),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print('===== Fetch URLs API Response =====');
    print('URL: ${ApiConstants.paTokenURL}');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('===================================');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data is Map<String, dynamic> ? data : null;
    }
    return null;
  }
}
