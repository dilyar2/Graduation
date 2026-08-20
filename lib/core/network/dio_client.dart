import 'package:dio/dio.dart';
import 'package:graduation2/core/network/api_config.dart';
import 'package:graduation2/core/network/auth_interceptor.dart';
import 'package:graduation2/core/storage/token_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class DioClient {
  final Dio dio;

  DioClient(TokenStorage tokenStorage)
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            sendTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 30),
            headers: const {
              'Accept': 'application/json',
            },
          ),
        ) {
    dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        dio: dio,
      ),
    );
  }
}
