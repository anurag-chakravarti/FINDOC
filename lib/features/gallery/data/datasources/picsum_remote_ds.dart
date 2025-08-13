import '../../../../core/network/http_client.dart';

class PicsumRemoteDataSource {
  final AppHttpClient http;
  PicsumRemoteDataSource(this.http);

  Future<List<Map<String, dynamic>>> fetchList({int limit = 10}) async {
    final uri = Uri.parse('https://picsum.photos/v2/list?limit=$limit');
    final res = await http.getJson(uri);
    return (res['data'] as List).cast<Map<String, dynamic>>();
  }
}