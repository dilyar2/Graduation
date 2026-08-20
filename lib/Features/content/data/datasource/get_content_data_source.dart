import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetContentDataSource {
  final DioClient dioClient;

  GetContentDataSource({required this.dioClient});

  Future<void> markContentCompleted({
    required int contentId,
    required int courseId,
    required int lastPosition,
  }) async {
    final response = await dioClient.dio.put(
      ApiEndpoints.progress(contentId),
      data: {
        'courseId': courseId,
        'lastPosition': lastPosition,
      },
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  Future<Uint8List> getContent({
    required int courseId,
    required int contentId,
  }) async {
    final response = await dioClient.dio.get(
      ApiEndpoints.courseContentFile(courseId: courseId, contentId: contentId),
      options: Options(responseType: ResponseType.bytes),
    );
    final data = response.data;
    if (data is Uint8List) {
      return data;
    }
    if (data is List<int>) {
      return Uint8List.fromList(data);
    }
    throw const FormatException('Invalid content payload format');
  }
}
