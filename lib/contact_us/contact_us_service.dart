import 'dart:convert';

import 'package:gayathri_varthalu/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class ContactUsService {
  Future<Map<String, dynamic>?> fetchContactUsData() async {
    final response = await http.get(Uri.parse(ApiConstants.contactUsEndPoint));
    print('===== Contact Us API Response =====');
    print('URL: ${ApiConstants.contactUsEndPoint}');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('====================================');
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    return null;
  }
}
