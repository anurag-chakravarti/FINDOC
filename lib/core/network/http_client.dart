import 'dart:convert';
import 'package:http/http.dart' as http;

class AppHttpClient {
  final _client = http.Client();

  Future<Map<String, dynamic>> getJson(Uri uri) async {
    final res = await _client.get(uri);
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }
    return {'data': json.decode(res.body)};
  }
}