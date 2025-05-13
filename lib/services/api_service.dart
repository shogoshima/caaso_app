import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<dynamic> get(String endpoint) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: idToken != null ? {'Authorization': 'Bearer $idToken'} : {},
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (idToken != null) 'Authorization': 'Bearer $idToken'
      },
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final json = jsonDecode(response.body);
    log(json.toString());
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    } else {
      throw Exception('${json['message']}');
    }
  }
}
