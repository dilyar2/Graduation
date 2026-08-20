part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
}

class LoadSearchSuggestionsEvent extends SearchEvent {
  final int limit;
  final int? days;

  const LoadSearchSuggestionsEvent({
    this.limit = 10,
    this.days,
  });

  @override
  List<Object?> get props => [limit, days];
}

class SearchCoursesEvent extends SearchEvent {
  final String? search;
  final String? tags;
  final String? categories;
  final int? teacherId;
  final int page;
  final int pageSize;
  final String? orderBy;
  final String direction;

  const SearchCoursesEvent({
    this.search,
    this.tags,
    this.categories,
    this.teacherId,
    this.page = 1,
    this.pageSize = 10,
    this.orderBy,
    this.direction = 'desc',
  });

  @override
  List<Object?> get props => [
        search,
        tags,
        categories,
        teacherId,
        page,
        pageSize,
        orderBy,
        direction,
      ];
}

class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();

  @override
  List<Object?> get props => const [];
}
