import 'dart:io';

import 'package:dio/dio.dart';

class ErrorMessageMapper {
  static String fromDio(DioException error) {
    final responseMessage = _extractResponseMessage(error.response?.data);
    if (responseMessage != null && responseMessage.trim().isNotEmpty) {
      return responseMessage;
    }

    return _fallbackMessage(error.type, error.error);
  }

  static String fromException(Object error) {
    if (error is DioException) {
      return fromDio(error);
    }

    final text = error.toString().toLowerCase();
    if (text.contains('reset by peer') ||
        text.contains('connection refused') ||
        text.contains('connection aborted') ||
        text.contains('failed host lookup')) {
      return 'The server is currently unavailable. Please try again later.';
    }

    if (text.contains('timeout')) {
      return 'The request timed out. Please try again.';
    }

    return 'Unable to load data. Please try again later.';
  }

  static String? _extractResponseMessage(dynamic data) {
    if (data is Map) {
      final message = data['message'] ?? data['title'] ?? data['detail'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return null;
  }

  static String _fallbackMessage(DioExceptionType type, Object? error) {
    final socketMessage = error is SocketException ? error.message : null;
    final errorText = error?.toString() ?? '';
    final normalized = (socketMessage ?? errorText).toLowerCase();

    if (type == DioExceptionType.connectionError ||
        normalized.contains('reset by peer') ||
        normalized.contains('connection refused') ||
        normalized.contains('connection aborted')) {
      return 'The server is currently unavailable. Please try again later.';
    }

    if (type == DioExceptionType.connectionTimeout ||
        type == DioExceptionType.sendTimeout ||
        type == DioExceptionType.receiveTimeout) {
      return 'The request timed out. Please try again.';
    }

    return 'Unable to load data. Please try again later.';
  }
}
