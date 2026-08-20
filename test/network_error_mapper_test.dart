import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graduation2/core/error/error_mapper.dart';

void main() {
  test('maps connection reset to a friendly user message', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/api/Course/category/'),
      type: DioExceptionType.connectionError,
      error: const SocketException('Connection reset by peer'),
    );

    expect(
      ErrorMessageMapper.fromDio(exception),
      contains('server is currently unavailable'),
    );
  });

  test('maps backend errors to a safe fallback message', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/api/Teacher/'),
      type: DioExceptionType.badResponse,
      error: 'Unexpected backend response',
    );

    expect(
      ErrorMessageMapper.fromDio(exception),
      contains('Unable to load data'),
    );
  });
}
