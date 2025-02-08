import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  static String? _baseUrl;

  // Private constructor
  ApiService._internal() {
    if (_baseUrl == null) {
      throw Exception('ApiService must be initialized with baseUrl before use');
    }
  }

  // Factory constructor to return the singleton instance
  factory ApiService() {
    return _instance;
  }

  // Static method to initialize the baseUrl (call this once at app startup)
  static void initialize(String baseUrl) {
    _baseUrl = baseUrl;
  }

  Future<dynamic> get(String endpoint, [String? token]) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: token != null ? {'Authorization': 'Bearer $token'} : {},
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data,
      [String? token]) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token'
      },
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final json = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    } else {
      throw Exception('[Error ${response.statusCode}] ${json['message']}');
    }
  }
}
