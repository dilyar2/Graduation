

part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final ProfileModel profileModel;

  const ProfileLoaded({
    required this.profileModel,
  });

  @override
  List<Object?> get props => [profileModel];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({
    required this.message,
  });

  @override
  List<Object?> get props => [message];
}
