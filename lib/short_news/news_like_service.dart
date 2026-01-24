import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gayathri_varthalu/constants/api_constants.dart';

class NewsLikeService {
  Future<bool> sendLikeDislike(
      {required String slno, required int option}) async {
    final response = await http.post(
      Uri.parse(ApiConstants.newsLikesEndPoint),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'slno': slno,
        'option': option,
      }),
    );
    print('===== News Like/Dislike API Response =====');
    print('URL: ${ApiConstants.newsLikesEndPoint}');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    print('==========================================');
    return response.statusCode == 200;
  }
}
