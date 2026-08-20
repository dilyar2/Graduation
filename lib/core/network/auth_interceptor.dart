import 'dart:async';

import 'package:dio/dio.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:graduation2/core/storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio dio;

  Completer<String?>? _refreshCompleter;

  AuthInterceptor({required this.tokenStorage, required this.dio});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final isRefreshRequest =
          _normalizePath(options.path) ==
          _normalizePath(ApiEndpoints.refreshToken);

      if (isRefreshRequest) {
        handler.next(options);
        return;
      }

      var token = await tokenStorage.getAccessToken();

      if (token != null && await tokenStorage.isAccessTokenExpired()) {
        final refreshToken = await tokenStorage.getRefreshToken();
        final userId = await tokenStorage.getUserId();

        if (refreshToken != null && refreshToken.isNotEmpty && userId != null) {
          token = await _refreshAccessToken(
            userId: userId,
            refreshToken: refreshToken,
          );
        }
      }

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      handler.next(options);
    } catch (e) {
      await tokenStorage.clearTokens();
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isRefreshRequest =
        _normalizePath(err.requestOptions.path) ==
        _normalizePath(ApiEndpoints.refreshToken);
    final alreadyRetried = err.requestOptions.extra['authRetry'] == true;

    if (err.response?.statusCode != 401 || isRefreshRequest || alreadyRetried) {
      handler.next(err);
      return;
    }

    final refreshToken = await tokenStorage.getRefreshToken();
    final userId = await tokenStorage.getUserId();

    if (refreshToken == null || refreshToken.isEmpty || userId == null) {
      await tokenStorage.clearTokens();
      handler.next(err);
      return;
    }

    try {
      final newAccessToken = await _refreshAccessToken(
        userId: userId,
        refreshToken: refreshToken,
      );

      if (newAccessToken == null || newAccessToken.isEmpty) {
        await tokenStorage.clearTokens();
        handler.next(err);
        return;
      }




      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';



      opts.extra['authRetry'] = true;

      final clonedResponse = await dio.fetch(opts);
      handler.resolve(clonedResponse);
    } catch (_) {
      await tokenStorage.clearTokens();
      handler.next(err);
    }
  }

  Future<String?> _refreshAccessToken({
    required int userId,
    required String refreshToken,
  }) async {
    final activeRefresh = _refreshCompleter;
    if (activeRefresh != null) {
      return activeRefresh.future;
    }

    final completer = Completer<String?>();
    _refreshCompleter = completer;

    try {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {
          'id': userId,
          'refreshToken': refreshToken,
        },
      );

      final data = response.data;
      if (data is! Map) {
        throw const FormatException('Invalid refresh response');
      }




      final newAccessToken = _readString(
        data,
        const ['access_token', 'accessToken', 'token'],
      );
      final newRefreshToken = _readString(
        data,
        const ['refresh_token', 'refreshToken'],
      );
      final expiresInMinutes = _readInt(
        data,
        const ['expiresInMinutes', 'expires_in_minutes', 'expiresIn'],
      );

      if (newAccessToken == null || newAccessToken.isEmpty) {
        throw const FormatException('Refresh response has no access token');
      }

      await tokenStorage.saveAccessToken(
        newAccessToken,
        expiresInMinutes: expiresInMinutes,
      );
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await tokenStorage.saveRefreshToken(newRefreshToken);
      }

      completer.complete(newAccessToken);
      return newAccessToken;
    } catch (e, stackTrace) {
      if (!completer.isCompleted) {
        completer.completeError(e, stackTrace);
      }
      rethrow;
    } finally {
      if (identical(_refreshCompleter, completer)) {
        _refreshCompleter = null;
      }
    }
  }

  int? _readInt(Map data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is int) return value;
      if (value is num) return value.toInt();
      if (value is String) {
        final parsed = int.tryParse(value);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }

  String? _readString(Map data, List<String> keys) {
    for (final key in keys) {
      final value = data[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }

  String _normalizePath(String path) {
    if (path.isEmpty) return path;
    final uri = Uri.tryParse(path);
    final normalized = uri?.path ?? path;
    return normalized.endsWith('/') && normalized.length > 1
        ? normalized.substring(0, normalized.length - 1)
        : normalized;
  }
}
