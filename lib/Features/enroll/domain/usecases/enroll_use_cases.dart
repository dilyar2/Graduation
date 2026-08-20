import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/enroll/data/models/enroll_model.dart';
import 'package:graduation2/Features/enroll/domain/repo/enroll_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';

@injectable
class EnrollUseCases {
  final EnrollRepo enrollRepo;
  EnrollUseCases({required this.enrollRepo});
  Future<Either<Failure, EnrollModel>> call({required int id}) {
    return enrollRepo.enroll(courseId: id);
  }


}
