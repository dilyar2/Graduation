import 'package:graduation2/core/network/api_endpoints.dart';
import 'package:graduation2/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReviewRemoteDataSource {
  final DioClient dioClient;

  ReviewRemoteDataSource(this.dioClient);

  Future<void> addReview({
    required int enrollmentId,
    required int rating,
    required String comment,
  }) async {
    await dioClient.dio.post(
      ApiEndpoints.review,
      data: {
        'enrollmentId': enrollmentId,
        'rating': rating,
        'comment': comment,
      },
    );
  }
}
