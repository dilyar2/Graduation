part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final List<String> recentSearches;
  final List<String> mostUsedSearches;

  const SearchState({
    this.recentSearches = const [],
    this.mostUsedSearches = const [],
  });

  @override
  List<Object?> get props => [
        recentSearches,
        mostUsedSearches,
      ];
}

class SearchInitial extends SearchState {
  const SearchInitial({
    super.recentSearches,
    super.mostUsedSearches,
  });
}

class SearchSuggestionsLoading extends SearchState {
  const SearchSuggestionsLoading({
    super.recentSearches,
    super.mostUsedSearches,
  });
}

class SearchSuggestionsSuccess extends SearchState {
  const SearchSuggestionsSuccess({
    super.recentSearches,
    super.mostUsedSearches,
  });
}

class SearchSuggestionsFailure extends SearchState {
  final String message;

  const SearchSuggestionsFailure({
    required this.message,
    super.recentSearches,
    super.mostUsedSearches,
  });

  @override
  List<Object?> get props => [
        message,
        ...super.props,
      ];
}

class SearchLoading extends SearchState {
  final String query;

  const SearchLoading({
    required this.query,
    super.recentSearches,
    super.mostUsedSearches,
  });

  @override
  List<Object?> get props => [
        query,
        ...super.props,
      ];
}

class SearchSuccess extends SearchState {
  final CoursesByCategoryModel courses;
  final String query;

  const SearchSuccess({
    required this.courses,
    required this.query,
    super.recentSearches,
    super.mostUsedSearches,
  });

  @override
  List<Object?> get props => [
        courses,
        query,
        ...super.props,
      ];
}

class SearchFailure extends SearchState {
  final String message;
  final String query;

  const SearchFailure({
    required this.message,
    required this.query,
    super.recentSearches,
    super.mostUsedSearches,
  });

  @override
  List<Object?> get props => [
        message,
        query,
        ...super.props,
      ];
}
