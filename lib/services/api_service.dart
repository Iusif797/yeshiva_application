import 'dart:async';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config.dart';

class ApiException implements Exception {
  final int? code;
  final String message;
  ApiException(this.message, {this.code});
  @override
  String toString() => 'ApiException($code): $message';
}

typedef UnauthorizedCallback = void Function();

class ApiService {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final UnauthorizedCallback onUnauthorized;

  ApiService({Dio? dio, FlutterSecureStorage? storage, required this.onUnauthorized})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: AppConfig.baseUrl, connectTimeout: const Duration(seconds: 10), receiveTimeout: const Duration(seconds: 20))),
        _storage = storage ?? const FlutterSecureStorage() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    }, onError: (e, handler) async {
      if (e.response?.statusCode == 401) {
        await clearToken();
        onUnauthorized();
      }
      handler.next(e);
    }));
  }

  Future<void> saveToken(String token) => _storage.write(key: 'api_token', value: token);
  Future<String?> getToken() => _storage.read(key: 'api_token');
  Future<void> clearToken() => _storage.delete(key: 'api_token');

  Future<T> _withRetry<T>(Future<T> Function() fn) async {
    int attempt = 0;
    int maxAttempts = 3;
    while (true) {
      try {
        return await fn();
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        final retriable = e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout || (status != null && status >= 500);
        if (!retriable || attempt >= maxAttempts - 1) {
          throw ApiException(e.message ?? 'network', code: status);
        }
        await Future.delayed(Duration(milliseconds: 300 * (1 << attempt)));
        attempt += 1;
      }
    }
  }

  Future<Map<String, dynamic>> getMe() => _withRetry(() async {
    final res = await _dio.get('/api/v1/me');
    if (res.statusCode == 200 && res.data is Map<String, dynamic>) return Map<String, dynamic>.from(res.data);
    throw ApiException('bad_response', code: res.statusCode);
  });

  Future<List<dynamic>> getCourses() => _withRetry(() async {
    final res = await _dio.get('/api/v1/courses');
    if (res.statusCode == 200 && res.data is List) return List<dynamic>.from(res.data);
    throw ApiException('bad_response', code: res.statusCode);
  });

  Future<Map<String, dynamic>> getLesson(int lessonId) => _withRetry(() async {
    final res = await _dio.get('/api/v1/lessons/$lessonId');
    if (res.statusCode == 200 && res.data is Map<String, dynamic>) return Map<String, dynamic>.from(res.data);
    throw ApiException('bad_response', code: res.statusCode);
  });

  Future<Map<String, dynamic>> extractLesson(int lessonId) => _withRetry(() async {
    final res = await _dio.post('/api/v1/lessons/$lessonId/extract');
    if (res.statusCode == 200 && res.data is Map<String, dynamic>) return Map<String, dynamic>.from(res.data);
    throw ApiException('bad_response', code: res.statusCode);
  });

  Future<Map<String, dynamic>> getNewWords(int lessonId, int studentId) => _withRetry(() async {
    final res = await _dio.get('/api/v1/lessons/$lessonId/new-words', queryParameters: {'student_id': studentId});
    if (res.statusCode == 200 && res.data is Map<String, dynamic>) return Map<String, dynamic>.from(res.data);
    throw ApiException('bad_response', code: res.statusCode);
  });

  Future<Map<String, dynamic>> exportToSrs(int studentId, String provider, List<int> wordIds) => _withRetry(() async {
    final res = await _dio.post('/api/v1/srs/export', data: {'student_id': studentId, 'provider': provider, 'words': wordIds});
    if (res.statusCode == 200 && res.data is Map<String, dynamic>) return Map<String, dynamic>.from(res.data);
    throw ApiException('bad_response', code: res.statusCode);
  });

  Future<Map<String, dynamic>> requestTranslation(int lexemeId) => _withRetry(() async {
    final res = await _dio.post('/api/v1/lexemes/$lexemeId/request-translation');
    if (res.statusCode == 200 && res.data is Map<String, dynamic>) return Map<String, dynamic>.from(res.data);
    throw ApiException('bad_response', code: res.statusCode);
  });

  Future<Map<String, dynamic>> uploadMedia(File file, {void Function(int, int)? onSendProgress}) => _withRetry(() async {
    final form = FormData.fromMap({'file': await MultipartFile.fromFile(file.path)});
    final res = await _dio.post('/api/v1/media/upload', data: form, onSendProgress: onSendProgress);
    if (res.statusCode == 200 && res.data is Map<String, dynamic>) return Map<String, dynamic>.from(res.data);
    throw ApiException('bad_response', code: res.statusCode);
  });
}


