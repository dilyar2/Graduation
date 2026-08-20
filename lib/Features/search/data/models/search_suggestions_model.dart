class SearchSuggestionsModel {
  final List<String> recent;
  final List<String> mostUsed;

  const SearchSuggestionsModel({
    this.recent = const [],
    this.mostUsed = const [],
  });
}
