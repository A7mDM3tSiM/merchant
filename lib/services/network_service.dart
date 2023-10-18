import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

enum Method { get, post }

class NetworkService {
  static late Dio _dio;
  static const String _baseUrl = 'http://104.198.26.113:8080/api/v1';

  /// initlize the dio services
  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
      ),
    );
  }

  static Future<Response> get({
    required String path,
    Map<String, dynamic>? params,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: params);
      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }

  static Future<Response> post({
    required String path,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }
}
