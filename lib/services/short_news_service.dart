import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gayathri_varthalu/constants/api_constants.dart';

class ShortNewsService {
  static Future<List<dynamic>> fetchShortNews() async {
    final response = await http.get(Uri.parse(ApiConstants.shortNewsEndpoint));
    print('===== Short News API Response =====');
    print('URL: ${ApiConstants.shortNewsEndpoint}');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('===================================');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'] is List ? data['result'] : [];
    } else {
      throw Exception('Failed to load short news');
    }
  }

  static Future<List<dynamic>> fetchAdvertisements() async {
    final response =
        await http.get(Uri.parse(ApiConstants.advertisementsEndPoint));
    print('===== Advertisements API Response =====');
    print('URL: ${ApiConstants.advertisementsEndPoint}');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('=======================================');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['result'] is List ? data['result'] : [];
    } else {
      throw Exception('Failed to load advertisements');
    }
  }
}
