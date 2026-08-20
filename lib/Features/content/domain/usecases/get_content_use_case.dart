import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/content/domain/repositories/content_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetContentUseCase {
  final ContentRepo repository;

  GetContentUseCase(this.repository);

  Future<Either<Failure, Uint8List>> call({
    required int courseId,
    required int contentId,
  }) {
    return repository.getContent(
      contentId: contentId,
      courseId: courseId,
    );
  }
  Future<Either<Failure, Unit>> markCompleted({
    required int contentId,
    required int courseId,
    required int lastPosition,
  }) {
    return repository.markContentCompleted(
      contentId: contentId,
      courseId: courseId,
      lastPosition: lastPosition,
    );
  }

}
