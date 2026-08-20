import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:injectable/injectable.dart';
@injectable
class ImageTeacherDataSource {
  final DioClient dioClient;

  ImageTeacherDataSource({required this.dioClient});
  Future<Uint8List> getTeacherImage(int id) async {
  final response = await dioClient.dio.get(
    ApiEndpoints.teacherImage(id),
    options: Options(
      responseType: ResponseType.bytes,
    ),
  );

  return Uint8List.fromList(response.data);
}

}
