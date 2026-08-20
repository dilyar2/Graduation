part of 'content_bloc.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class GetContentEvent extends ContentEvent {
  final int courseId;
  final int contentId;

  const GetContentEvent({
    required this.courseId,
    required this.contentId,
  });

  @override
  List<Object?> get props => [courseId, contentId];
}

class MarkContentCompletedEvent extends ContentEvent {
  final int contentId;
  final int courseId;
  final int lastPosition;

  const MarkContentCompletedEvent({
    required this.contentId,
    required this.courseId,
    required this.lastPosition,
  });

  @override
  List<Object?> get props => [contentId, courseId, lastPosition];
}
