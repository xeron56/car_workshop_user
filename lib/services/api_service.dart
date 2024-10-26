// lib/services/api_service.dart

import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  ApiService() {
    _dio.options.baseUrl = 'https://api.example.com';
    _dio.options.connectTimeout = 5000 as Duration?;
    _dio.options.receiveTimeout = 3000 as Duration?;
  }

  Future<Response> getBookings() async {
    try {
      Response response = await _dio.get('/bookings');
      return response;
    } catch (e) {
      throw Exception('Failed to load bookings');
    }
  }

  // Add other API methods as needed
}
