import 'package:dartz/dartz.dart';
import 'package:graduation2/Features/sections/data/models/section_model.dart';
import 'package:graduation2/Features/sections/domain/repositories/section_repo.dart';
import 'package:graduation2/core/error/failure.dart';
import 'package:injectable/injectable.dart';
@injectable
class GetSectionUsecase {
  final SectionRepo sectionRepo;

  GetSectionUsecase({required this.sectionRepo});

  Future<Either<Failure, SectionModel>> call({required int id}) {
    return sectionRepo.getSection(id: id);
  }
}
