part of 'content_bloc.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final Uint8List file;
  final bool updatingProgress;
  final bool completed;
  final String? progressError;

  const ContentLoaded({
    required this.file,
    this.updatingProgress = false,
    this.completed = false,
    this.progressError,
  });

  ContentLoaded copyWith({
    bool? updatingProgress,
    bool? completed,
    String? progressError,
    bool clearError = false,
  }) {
    return ContentLoaded(
      file: file,
      updatingProgress: updatingProgress ?? this.updatingProgress,
      completed: completed ?? this.completed,
      progressError: clearError ? null : (progressError ?? this.progressError),
    );
  }

  @override
  List<Object?> get props => [file, updatingProgress, completed, progressError];
}

class ContentError extends ContentState {
  final String message;

  const ContentError({required this.message});

  @override
  List<Object?> get props => [message];
}
