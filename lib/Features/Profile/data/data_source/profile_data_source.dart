import 'package:graduation2/Features/Profile/data/models/profile_model.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:injectable/injectable.dart';
@injectable
class ProfileRemoteDataSource {
  final DioClient dioClient;

  ProfileRemoteDataSource(this.dioClient);

  Future<ProfileModel> getProfile() async {
    final response = await dioClient.dio.get(ApiEndpoints.meInfo);

    return ProfileModel.fromJson(response.data);
  }
}

