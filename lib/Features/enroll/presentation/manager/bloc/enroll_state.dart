part of 'enroll_bloc.dart';

sealed class EnrollState extends Equatable {
  const EnrollState();

  @override
  List<Object> get props => [];
}

final class EnrollInitial extends EnrollState {}

final class EnrollLoading extends EnrollState {}

final class EnrollSuccess extends EnrollState {
  final EnrollModel enrollModel;

  const EnrollSuccess({required this.enrollModel});

  @override
  List<Object> get props => [enrollModel];
}

final class EnrollFailure extends EnrollState {
  final String message;

  const EnrollFailure({required this.message});

  @override
  List<Object> get props => [message];
}
