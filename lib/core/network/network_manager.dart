abstract class NetworkManager {
  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters});
}
