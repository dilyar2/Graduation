import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:graduation2/Features/courses/data/models/courses_by_category_model.dart';
import 'package:graduation2/Features/search/domain/usecases/search_usecase.dart';
import 'package:injectable/injectable.dart';

part 'search_event.dart';
part 'search_state.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchCoursesUseCase searchCoursesUseCase;

  int _requestGeneration = 0;

  List<String> _recentSearches = const [];
  List<String> _mostUsedSearches = const [];

  SearchBloc(this.searchCoursesUseCase)
      : super(const SearchInitial()) {
    on<LoadSearchSuggestionsEvent>(_onLoadSuggestions);
    on<SearchCoursesEvent>(_onSearchCourses);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onLoadSuggestions(
    LoadSearchSuggestionsEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(
      SearchSuggestionsLoading(
        recentSearches: _recentSearches,
        mostUsedSearches: _mostUsedSearches,
      ),
    );

    final result = await searchCoursesUseCase.getSearchSuggestions(
      limit: event.limit,
      days: event.days,
    );

    if (emit.isDone) return;

    result.fold(
      (failure) => emit(
        SearchSuggestionsFailure(
          message: failure.message,
          recentSearches: _recentSearches,
          mostUsedSearches: _mostUsedSearches,
        ),
      ),
      (suggestions) {
        _recentSearches = suggestions.recent;
        _mostUsedSearches = suggestions.mostUsed;

        emit(
          SearchSuggestionsSuccess(
            recentSearches: _recentSearches,
            mostUsedSearches: _mostUsedSearches,
          ),
        );
      },
    );
  }

  Future<void> _onSearchCourses(
    SearchCoursesEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.search?.trim() ?? '';

    if (query.isEmpty) {
      _requestGeneration++;
      emit(
        SearchInitial(
          recentSearches: _recentSearches,
          mostUsedSearches: _mostUsedSearches,
        ),
      );
      return;
    }

    final requestGeneration = ++_requestGeneration;

    emit(
      SearchLoading(
        query: query,
        recentSearches: _recentSearches,
        mostUsedSearches: _mostUsedSearches,
      ),
    );

    final result = await searchCoursesUseCase(
      search: query,
      tags: event.tags,
      categories: event.categories,
      teacherId: event.teacherId,
      page: event.page,
      pageSize: event.pageSize,
      orderBy: event.orderBy,
      direction: event.direction,
    );

    if (requestGeneration != _requestGeneration || emit.isDone) {
      return;
    }

    result.fold(
      (failure) => emit(
        SearchFailure(
          message: failure.message,
          query: query,
          recentSearches: _recentSearches,
          mostUsedSearches: _mostUsedSearches,
        ),
      ),
      (courses) => emit(
        SearchSuccess(
          courses: courses,
          query: query,
          recentSearches: _recentSearches,
          mostUsedSearches: _mostUsedSearches,
        ),
      ),
    );
  }

  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<SearchState> emit,
  ) {
    _requestGeneration++;

    emit(
      SearchInitial(
        recentSearches: _recentSearches,
        mostUsedSearches: _mostUsedSearches,
      ),
    );
  }
}
