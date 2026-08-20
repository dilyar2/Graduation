import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/Profile/data/models/profile_model.dart';
import 'package:graduation2/Features/Profile/domin/usecases/profile_usecases.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileBloc({
    required this.getProfileUseCase,
  }) : super(ProfileInitial()) {

    on<GetProfileEvent>(_getProfile);
  }

  Future<void> _getProfile(
    GetProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {

    emit(ProfileLoading());

    final result = await getProfileUseCase();

    result.fold(
      (failure) {
        emit(ProfileError(message: failure.message));
      },
      (profile) {
        emit(ProfileLoaded(profileModel: profile));
      },
    );
  }
}
