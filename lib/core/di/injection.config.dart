// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:get_it/get_it.dart' as _i174;
import 'package:graduation2/core/network/dio_client.dart' as _i1012;
import 'package:graduation2/core/storage/enrollment_storage.dart' as _i44;
import 'package:graduation2/core/storage/token_storage.dart' as _i43;
import 'package:graduation2/Features/authentication/data/datasource/auth_data_source.dart'
    as _i698;
import 'package:graduation2/Features/authentication/data/repositories/auth_repo_impl.dart'
    as _i217;
import 'package:graduation2/Features/authentication/domain/repositories/auth_repo.dart'
    as _i111;
import 'package:graduation2/Features/authentication/domain/usecases/login_use_case.dart'
    as _i1068;
import 'package:graduation2/Features/authentication/domain/usecases/register_use_case.dart'
    as _i915;
import 'package:graduation2/Features/authentication/presentation/pages/manager/bloc/auth_bloc.dart'
    as _i207;
import 'package:graduation2/Features/categories/data/datasources/category_data_source.dart'
    as _i437;
import 'package:graduation2/Features/categories/data/repositories/category_repo_impl.dart'
    as _i710;
import 'package:graduation2/Features/categories/domain/repositories/category_repo.dart'
    as _i416;
import 'package:graduation2/Features/categories/domain/usecases/get_all_categories_use_case.dart'
    as _i410;
import 'package:graduation2/Features/categories/presentation/manager/bloc/category_bloc.dart'
    as _i1068;
import 'package:graduation2/Features/content/data/datasource/get_content_data_source.dart'
    as _i65;
import 'package:graduation2/Features/content/data/repositories/content_repo_impl.dart'
    as _i208;
import 'package:graduation2/Features/content/domain/repositories/content_repo.dart'
    as _i537;
import 'package:graduation2/Features/content/domain/usecases/get_content_use_case.dart'
    as _i883;
import 'package:graduation2/Features/content/presentation/manager/bloc/content_bloc.dart'
    as _i544;
import 'package:graduation2/Features/course_info/data/datasource/course_info_data_source.dart'
    as _i348;
import 'package:graduation2/Features/course_info/data/repositories/course_info_repo_impl.dart'
    as _i894;
import 'package:graduation2/Features/course_info/domain/repositories/course_info_repo.dart'
    as _i379;
import 'package:graduation2/Features/course_info/domain/usecases/course_info_use_case.dart'
    as _i509;
import 'package:graduation2/Features/course_info/presentation/manager/bloc/courseinfo_bloc.dart'
    as _i1029;
import 'package:graduation2/Features/courses/data/datasources/courses_data_source.dart'
    as _i1062;
import 'package:graduation2/Features/courses/data/repositories/course_repo_impl.dart'
    as _i138;
import 'package:graduation2/Features/courses/domain/repositories/courses_repo.dart'
    as _i670;
import 'package:graduation2/Features/courses/domain/usecases/get_courses_by_category_usecase.dart'
    as _i38;
import 'package:graduation2/Features/courses/presentation/manager/bloc/courses_category_bloc.dart'
    as _i1004;
import 'package:graduation2/Features/courses_enrollment/data/data_source/courses_enrollment_data_source.dart'
    as _i67;
import 'package:graduation2/Features/courses_enrollment/data/repo/courses_enrollment_repo_impl.dart'
    as _i540;
import 'package:graduation2/Features/courses_enrollment/domain/repo/course_enrollment_repo.dart'
    as _i732;
import 'package:graduation2/Features/courses_enrollment/domain/usecases/course_enrollment_use_cases.dart'
    as _i115;
import 'package:graduation2/Features/courses_enrollment/presentation/manager/bloc/course_enrollment_bloc.dart'
    as _i291;
import 'package:graduation2/Features/enroll/data/datasource/enroll_data_source.dart'
    as _i158;
import 'package:graduation2/Features/enroll/data/repo/enroll_repo_impl.dart'
    as _i168;
import 'package:graduation2/Features/enroll/domain/repo/enroll_repo.dart'
    as _i182;
import 'package:graduation2/Features/enroll/domain/usecases/enroll_use_cases.dart'
    as _i908;
import 'package:graduation2/Features/enroll/presentation/manager/bloc/enroll_bloc.dart'
    as _i87;
import 'package:graduation2/Features/payment/data/datasource/payment_data_source.dart'
    as _i359;
import 'package:graduation2/Features/payment/data/repo/payment_repo_impl.dart'
    as _i514;
import 'package:graduation2/Features/payment/domain/repo/payment_repo.dart'
    as _i665;
import 'package:graduation2/Features/payment/domain/usecases/pay_enrollment_use_case.dart'
    as _i413;
import 'package:graduation2/Features/payment/presentation/manager/bloc/payment_bloc.dart'
    as _i346;
import 'package:graduation2/Features/Profile/data/data_source/profile_data_source.dart'
    as _i347;
import 'package:graduation2/Features/Profile/data/repo/profile_repo_impl.dart'
    as _i1040;
import 'package:graduation2/Features/Profile/domin/repo/profile_repo.dart'
    as _i76;
import 'package:graduation2/Features/Profile/domin/usecases/profile_usecases.dart'
    as _i889;
import 'package:graduation2/Features/Profile/presentation/manager/bloc/profile_bloc.dart'
    as _i116;
import 'package:graduation2/Features/Review/data/dataSource/review_data_source.dart'
    as _i175;
import 'package:graduation2/Features/Review/data/repositories/review_repo_impl.dart'
    as _i923;
import 'package:graduation2/Features/Review/domain/repo/review_repo.dart'
    as _i368;
import 'package:graduation2/Features/Review/domain/usecases/review_use_case.dart'
    as _i967;
import 'package:graduation2/Features/Review/presentation/manager/bloc/review_bloc.dart'
    as _i555;
import 'package:graduation2/Features/search/data/repo/Search_repo_impl.dart'
    as _i694;
import 'package:graduation2/Features/search/data/search_data_source.dart'
    as _i830;
import 'package:graduation2/Features/search/domain/repo/search_repo.dart'
    as _i261;
import 'package:graduation2/Features/search/domain/usecases/search_usecase.dart'
    as _i545;
import 'package:graduation2/Features/search/presentaion/bloc/search_bloc.dart'
    as _i473;
import 'package:graduation2/Features/sections/data/dataSources/section_data_source.dart'
    as _i137;
import 'package:graduation2/Features/sections/data/repositories/section_repo_impl.dart'
    as _i238;
import 'package:graduation2/Features/sections/domain/repositories/section_repo.dart'
    as _i175;
import 'package:graduation2/Features/sections/domain/usecases/get_section_usecase.dart'
    as _i732;
import 'package:graduation2/Features/sections/presentation/manager/bloc/section_bloc.dart'
    as _i1064;
import 'package:graduation2/Features/teacher/data/datasources/image_teacher_data_source.dart'
    as _i446;
import 'package:graduation2/Features/teacher/data/datasources/teacher_data_source.dart'
    as _i508;
import 'package:graduation2/Features/teacher/data/models/repositories/teacher_repo_impl.dart'
    as _i498;
import 'package:graduation2/Features/teacher/domain/repositories/teacher_repo.dart'
    as _i426;
import 'package:graduation2/Features/teacher/domain/usecases/get_all_courses_to_teacher_usecases.dart'
    as _i494;
import 'package:graduation2/Features/teacher/domain/usecases/get_all_teaches_usecase.dart'
    as _i820;
import 'package:graduation2/Features/teacher/domain/usecases/get_teacher_img_usecase.dart'
    as _i25;
import 'package:graduation2/Features/teacher/presentation/manager/bloc/course_by_teacher_bloc.dart'
    as _i548;
import 'package:graduation2/Features/teacher/presentation/manager/bloc/teacher_bloc.dart'
    as _i761;
import 'package:injectable/injectable.dart' as _i526;

import 'package:graduation2/Features/quiz/data/datasources/quiz_data_source.dart'
    as _i1200;
import 'package:graduation2/Features/quiz/data/repositories/quiz_repo_impl.dart'
    as _i1201;
import 'package:graduation2/Features/quiz/domain/repositories/quiz_repo.dart'
    as _i1202;
import 'package:graduation2/Features/quiz/domain/usecases/get_section_quiz_use_case.dart'
    as _i1203;
import 'package:graduation2/Features/quiz/presentation/manager/bloc/quiz_bloc.dart'
    as _i1204;

extension GetItInjectableX on _i174.GetIt {
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i44.EnrollmentStorage>(() => _i44.EnrollmentStorage());
    gh.lazySingleton<_i43.TokenStorage>(() => _i43.TokenStorage());
    gh.factory<_i1012.DioClient>(
      () => _i1012.DioClient(gh<_i43.TokenStorage>()),
    );
    gh.factory<_i698.AuthRemoteDataSource>(
      () => _i698.AuthRemoteDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i437.CategoryDataSource>(
      () => _i437.CategoryDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i65.GetContentDataSource>(
      () => _i65.GetContentDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i348.CourseInfoDataSource>(
      () => _i348.CourseInfoDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i1062.CourseRemoteDataSource>(
      () => _i1062.CourseRemoteDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i67.CourseEnrollmentDataSource>(
      () => _i67.CourseEnrollmentDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i158.EnrollDataSource>(
      () => _i158.EnrollDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i359.PaymentDataSource>(
      () => _i359.PaymentDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i137.SectionDataSource>(
      () => _i137.SectionDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i446.ImageTeacherDataSource>(
      () => _i446.ImageTeacherDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i508.TeacherDataSource>(
      () => _i508.TeacherDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i1200.QuizDataSource>(
      () => _i1200.QuizDataSource(dioClient: gh<_i1012.DioClient>()),
    );
    gh.factory<_i537.ContentRepo>(
      () => _i208.RepoContentImpl(
        getContentDataSource: gh<_i65.GetContentDataSource>(),
      ),
    );
    gh.factory<_i1202.QuizRepo>(
      () => _i1201.QuizRepoImpl(quizDataSource: gh<_i1200.QuizDataSource>()),
    );
    gh.factory<_i111.AuthRepo>(
      () =>
          _i217.AuthRepoImpl(authDataSource: gh<_i698.AuthRemoteDataSource>()),
    );
    gh.factory<_i182.EnrollRepo>(
      () =>
          _i168.EnrollRepoImpl(enrollDataSource: gh<_i158.EnrollDataSource>()),
    );
    gh.factory<_i732.CourseEnrollmentRepo>(
      () => _i540.CoursesEnrollmentRepoImpl(
        courseEnrollmentDataSource: gh<_i67.CourseEnrollmentDataSource>(),
      ),
    );
    gh.factory<_i426.TeacherRepo>(
      () => _i498.TeacherRepoImpl(
        gh<_i446.ImageTeacherDataSource>(),
        teacherDataSource: gh<_i508.TeacherDataSource>(),
      ),
    );
    gh.factory<_i416.CategoryRepo>(
      () => _i710.CategoryRepoImpl(
        categoryDataSource: gh<_i437.CategoryDataSource>(),
      ),
    );
    gh.factory<_i670.CoursesRepo>(
      () => _i138.CoursesRepoImpl(
        courseRemoteDataSource: gh<_i1062.CourseRemoteDataSource>(),
      ),
    );
    gh.factory<_i347.ProfileRemoteDataSource>(
      () => _i347.ProfileRemoteDataSource(gh<_i1012.DioClient>()),
    );
    gh.factory<_i175.ReviewRemoteDataSource>(
      () => _i175.ReviewRemoteDataSource(gh<_i1012.DioClient>()),
    );
    gh.factory<_i830.SearchRemoteDataSource>(
      () => _i830.SearchRemoteDataSource(gh<_i1012.DioClient>()),
    );
    gh.factory<_i1068.LoginUseCase>(
      () => _i1068.LoginUseCase(authRepo: gh<_i111.AuthRepo>()),
    );
    gh.factory<_i915.RegisterUseCase>(
      () => _i915.RegisterUseCase(authRepo: gh<_i111.AuthRepo>()),
    );
    gh.factory<_i368.ReviewRepo>(
      () => _i923.ReviewRepoImpl(
        reviewRemoteDataSource: gh<_i175.ReviewRemoteDataSource>(),
      ),
    );
    gh.factory<_i820.GetAllTeachesUsecase>(
      () => _i820.GetAllTeachesUsecase(teacherRepo: gh<_i426.TeacherRepo>()),
    );
    gh.factory<_i25.GetTeacherImgUsecase>(
      () => _i25.GetTeacherImgUsecase(teacherRepo: gh<_i426.TeacherRepo>()),
    );
    gh.factory<_i908.EnrollUseCases>(
      () => _i908.EnrollUseCases(enrollRepo: gh<_i182.EnrollRepo>()),
    );
    gh.factory<_i38.GetCoursesByCategoryUseCase>(
      () =>
          _i38.GetCoursesByCategoryUseCase(repository: gh<_i670.CoursesRepo>()),
    );
    gh.factory<_i175.SectionRepo>(
      () => _i238.SectionRepoImpl(
        sectionDataSource: gh<_i137.SectionDataSource>(),
      ),
    );
    gh.factory<_i665.PaymentRepo>(
      () => _i514.PaymentRepoImpl(
        paymentDataSource: gh<_i359.PaymentDataSource>(),
      ),
    );
    gh.factory<_i1004.CourseBloc>(
      () => _i1004.CourseBloc(
        getCoursesByCategoryUseCase: gh<_i38.GetCoursesByCategoryUseCase>(),
      ),
    );
    gh.factory<_i1068.CategoryBloc>(
      () => _i1068.CategoryBloc(gh<_i416.CategoryRepo>()),
    );
    gh.factory<_i410.GetAllCategoriesUseCase>(
      () =>
          _i410.GetAllCategoriesUseCase(categoryRepo: gh<_i416.CategoryRepo>()),
    );
    gh.factory<_i379.CourseInfoRepo>(
      () => _i894.CourseInfoRepoImpl(
        courseInfoDataSource: gh<_i348.CourseInfoDataSource>(),
      ),
    );
    gh.factory<_i413.PayEnrollmentUseCase>(
      () => _i413.PayEnrollmentUseCase(paymentRepo: gh<_i665.PaymentRepo>()),
    );
    gh.factory<_i115.CourseEnrollmentUseCases>(
      () => _i115.CourseEnrollmentUseCases(
        courseEnrollmentRepo: gh<_i732.CourseEnrollmentRepo>(),
      ),
    );
    gh.factory<_i509.CourseInfoUseCase>(
      () => _i509.CourseInfoUseCase(courseInfoRepo: gh<_i379.CourseInfoRepo>()),
    );
    gh.factory<_i291.CoursesEnrollmentBloc>(
      () => _i291.CoursesEnrollmentBloc(
        getCoursesEnrollmentUseCase: gh<_i115.CourseEnrollmentUseCases>(),
      ),
    );
    gh.factory<_i967.AddReviewUseCases>(
      () => _i967.AddReviewUseCases(reviewRepo: gh<_i368.ReviewRepo>()),
    );
    gh.factory<_i346.PaymentBloc>(
      () => _i346.PaymentBloc(
        payEnrollmentUseCase: gh<_i413.PayEnrollmentUseCase>(),
      ),
    );
    gh.factory<_i76.ProfileRepo>(
      () => _i1040.ProfileRepoImpl(
        profileDataSource: gh<_i347.ProfileRemoteDataSource>(),
      ),
    );
    gh.factory<_i883.GetContentUseCase>(
      () => _i883.GetContentUseCase(gh<_i537.ContentRepo>()),
    );
    gh.factory<_i1203.GetSectionQuizUseCase>(
      () => _i1203.GetSectionQuizUseCase(gh<_i1202.QuizRepo>()),
    );
    gh.factory<_i494.GetAllCoursesToTeacherUsecases>(
      () => _i494.GetAllCoursesToTeacherUsecases(
        coursesRepo: gh<_i670.CoursesRepo>(),
      ),
    );
    gh.factory<_i207.AuthBloc>(
      () => _i207.AuthBloc(
        loginUseCase: gh<_i1068.LoginUseCase>(),
        registerUseCase: gh<_i915.RegisterUseCase>(),
        authRepo: gh<_i111.AuthRepo>(),
        tokenStorage: gh<_i43.TokenStorage>(),
        enrollmentStorage: gh<_i44.EnrollmentStorage>(),
      ),
    );
    gh.factory<_i1029.CourseInfoBloc>(
      () => _i1029.CourseInfoBloc(
        courseInfoUseCase: gh<_i509.CourseInfoUseCase>(),
      ),
    );
    gh.factory<_i761.TeacherBloc>(
      () => _i761.TeacherBloc(
        gh<_i820.GetAllTeachesUsecase>(),
        gh<_i25.GetTeacherImgUsecase>(),
      ),
    );
    gh.factory<_i261.SearchRepo>(
      () => _i694.SearchRepositoryImpl(
        remoteDataSource: gh<_i830.SearchRemoteDataSource>(),
      ),
    );
    gh.factory<_i732.GetSectionUsecase>(
      () => _i732.GetSectionUsecase(sectionRepo: gh<_i175.SectionRepo>()),
    );
    gh.factory<_i545.SearchCoursesUseCase>(
      () => _i545.SearchCoursesUseCase(gh<_i261.SearchRepo>()),
    );
    gh.factory<_i548.TeacherCoursesBloc>(
      () => _i548.TeacherCoursesBloc(
        getAllCoursesToTeacherUsecases:
            gh<_i494.GetAllCoursesToTeacherUsecases>(),
      ),
    );
    gh.factory<_i87.EnrollBloc>(
      () => _i87.EnrollBloc(enrollUseCase: gh<_i908.EnrollUseCases>()),
    );
    gh.factory<_i473.SearchBloc>(
      () => _i473.SearchBloc(gh<_i545.SearchCoursesUseCase>()),
    );
    gh.factory<_i544.ContentBloc>(
      () => _i544.ContentBloc(getContentUseCase: gh<_i883.GetContentUseCase>()),
    );
    gh.factory<_i1064.SectionBloc>(
      () =>
          _i1064.SectionBloc(getSectionUsecase: gh<_i732.GetSectionUsecase>()),
    );
    gh.factory<_i555.ReviewBloc>(
      () => _i555.ReviewBloc(addReviewUseCases: gh<_i967.AddReviewUseCases>()),
    );
    gh.factory<_i889.GetProfileUseCase>(
      () => _i889.GetProfileUseCase(profileRepo: gh<_i76.ProfileRepo>()),
    );
    gh.factory<_i116.ProfileBloc>(
      () => _i116.ProfileBloc(getProfileUseCase: gh<_i889.GetProfileUseCase>()),
    );
    return this;
  }
}
