import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:graduation2/Features/content/data/datasource/get_content_data_source.dart';
import 'package:graduation2/Features/content/domain/repositories/content_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ContentRepo)
class RepoContentImpl implements ContentRepo {
  final GetContentDataSource getContentDataSource;

  RepoContentImpl({required this.getContentDataSource});

  @override
  Future<Either<Failure, Unit>> markContentCompleted({
    required int contentId,
    required int courseId,
    required int lastPosition,
  }) async {
    try {
      await getContentDataSource.markContentCompleted(
        contentId: contentId,
        courseId: courseId,
        lastPosition: lastPosition,
      );
      return const Right(unit);
    } on DioException catch (e) {
      final data = e.response?.data;
      final serverMessage = data is Map && data['message'] != null
          ? data['message'].toString()
          : data?.toString();
      return Left(
        ServerFailure(
          serverMessage ?? e.message ?? 'Failed to update progress',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Unexpected error while updating progress: $e'));
    }
  }

  @override
  Future<Either<Failure, Uint8List>> getContent({
    required int contentId,
    required int courseId,
  }) async {
    try {
      final result = await getContentDataSource.getContent(
        contentId: contentId,
        courseId: courseId,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to load content file'));
    } on FormatException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error while loading content: $e'));
    }
  }
}
