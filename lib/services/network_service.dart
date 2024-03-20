import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/network_response.dart';

class NetworkService {
  NetworkService();
  // "https://allevents.s3.amazonaws.com/tests/categories.json";
  String baseUrl = "https://allevents.s3.amazonaws.com/tests/";

  Future<dynamic> get(String endpoint) async {
    try {

      String url = "$baseUrl$endpoint.json";
      print(url);
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ResponseModel(statusCode: response.statusCode, data: data);
      }

      return ResponseModel(statusCode: response.statusCode, data: null);
    } catch (e) {
      if (e.toString().contains('Failed host lookup')) {
        throw ('NO_CONNECTION');
      } else {
        rethrow;
      }
    }
  }
}
