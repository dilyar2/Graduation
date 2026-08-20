import 'package:graduation2/Features/authentication/data/models/login_request_model.dart';
import 'package:graduation2/Features/authentication/data/models/login_response_model.dart';
import 'package:graduation2/Features/authentication/data/models/register_request_model.dart';
import 'package:graduation2/Features/authentication/data/models/register_response_model.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSource({required this.dioClient});

  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );

    return RegisterResponseModel.fromJson(_asMap(response.data, 'register'));
  }

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );

    return LoginResponseModel.fromJson(_asMap(response.data, 'login'));
  }

  Future<int> getCurrentUserId() async {
    final response = await dioClient.dio.get(ApiEndpoints.meInfo);
    final data = _asMap(response.data, 'current user');
    final id = data['id'];

    if (id is int && id > 0) {
      return id;
    }
    if (id is num && id.toInt() > 0) {
      return id.toInt();
    }

    throw const FormatException('Current user response has no valid id');
  }

  Future<void> logout() async {
    await dioClient.dio.post(ApiEndpoints.logout);
  }

  Map<String, dynamic> _asMap(dynamic value, String operation) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    throw FormatException('Invalid $operation response');
  }
}
