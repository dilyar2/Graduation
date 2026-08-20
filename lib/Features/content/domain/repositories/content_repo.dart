import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:graduation2/core/error/failure.dart';

abstract class ContentRepo {
  Future<Either<Failure, Unit>> markContentCompleted({
    required int contentId,
    required int courseId,
    required int lastPosition,
  });
  Future<Either<Failure, Uint8List>> getContent({
    required int contentId,
    required int courseId,
  });
}
