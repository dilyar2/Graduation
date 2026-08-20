import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation2/Features/search/presentaion/bloc/search_bloc.dart';
import 'package:graduation2/Features/search/presentaion/widgets/custom_search_widget.dart';
import 'package:graduation2/app_router.dart';
import 'package:graduation2/core/di/injection.dart';
import 'package:graduation2/core/storage/search_history_storage.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchBloc>()
        ..add(const LoadSearchSuggestionsEvent()),
      child: const _SearchPageBody(),
    );
  }
}

class _SearchPageBody extends StatefulWidget {
  const _SearchPageBody();

  @override
  State<_SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<_SearchPageBody> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final SearchHistoryStorage _historyStorage = SearchHistoryStorage();
  Set<String> _hiddenRecent = <String>{};

  @override
  void initState() {
    super.initState();
    _loadHiddenRecent();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  Future<void> _loadHiddenRecent() async {
    await _historyStorage.init();
    if (!mounted) return;
    setState(() {
      _hiddenRecent = _historyStorage.getHiddenRecent();
    });
  }

  Future<void> _removeRecentSearch(String query) async {
    await _historyStorage.hideRecent(query);
    if (!mounted) return;
    setState(() {
      _hiddenRecent = {..._hiddenRecent, query.trim().toLowerCase()};
    });
  }

  List<String> _visibleRecent(List<String> recent) {
    return recent
        .where((query) => !_hiddenRecent.contains(query.trim().toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _search(String value) {




  }

  void _submitSearch(String value) {
    final query = value.trim();
    if (query.isEmpty) return;

    context.read<SearchBloc>().add(
          SearchCoursesEvent(search: query),
        );
  }

  void _submitSuggestion(String query) {
    final normalized = query.trim();

    if (normalized.isEmpty) return;

    _controller
      ..text = normalized
      ..selection = TextSelection.collapsed(
        offset: normalized.length,
      );

    context.read<SearchBloc>().add(
          SearchCoursesEvent(search: normalized),
        );
  }

  void _clearSearch() {
    _controller.clear();

    context.read<SearchBloc>().add(
          const ClearSearchEvent(),
        );

    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: theme.textTheme.titleLarge,
        ),
        leading: IconButton(
          tooltip: 'Back',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: CustomSearchWidget(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                onChanged: _search,
                onSubmitted: _submitSearch,
                onClear: _clearSearch,
                readOnly: false,
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial ||
                      state is SearchSuggestionsLoading ||
                      state is SearchSuggestionsSuccess ||
                      state is SearchSuggestionsFailure) {
                    return _SuggestionsView(
                      recentSearches: _visibleRecent(state.recentSearches),
                      mostUsedSearches: state.mostUsedSearches,
                      loading: state is SearchSuggestionsLoading,
                      error: state is SearchSuggestionsFailure,
                      onRetry: () {
                        context.read<SearchBloc>().add(
                              const LoadSearchSuggestionsEvent(),
                            );
                      },
                      onSelected: _submitSuggestion,
                      onRemoveRecent: _removeRecentSearch,
                    );
                  }

                  if (state is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is SearchFailure) {
                    return _SearchErrorState(
                      message: state.message,
                      onRetry: () => _submitSearch(state.query),
                    );
                  }

                  if (state is SearchSuccess) {
                    final courses = state.courses.items;

                    if (courses.isEmpty) {
                      return _SearchEmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'No courses found',
                        message:
                            'Try another keyword or a shorter search.',
                      );
                    }

                    return ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                      itemCount: courses.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final course = courses[index];

                        return Card(
                          margin: EdgeInsets.zero,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: _CourseThumbnail(
                              imageUrl: course.imageUrl,
                            ),
                            title: Text(
                              course.title?.trim().isNotEmpty == true
                                  ? course.title!
                                  : 'Untitled course',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                course.description?.trim().isNotEmpty ==
                                        true
                                    ? course.description!
                                    : 'No description available.',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            trailing: course.price != null
                                ? Text(
                                    course.price!.toStringAsFixed(2),
                                    style: theme.textTheme.titleSmall
                                        ?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : const Icon(
                                    Icons.chevron_right_rounded,
                                  ),
                                                        onTap: course.id == null
                                ? null
                                : () => Navigator.pushNamed(
                                      context,
                                      AppRouter.courseDetails,
                                      arguments: course.id!,
                                    ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionsView extends StatelessWidget {
  final List<String> recentSearches;
  final List<String> mostUsedSearches;
  final bool loading;
  final bool error;
  final VoidCallback onRetry;
  final ValueChanged<String> onSelected;
  final ValueChanged<String>? onRemoveRecent;

  const _SuggestionsView({
    required this.recentSearches,
    required this.mostUsedSearches,
    required this.loading,
    required this.error,
    required this.onRetry,
    required this.onSelected,
    this.onRemoveRecent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    if (loading &&
        recentSearches.isEmpty &&
        mostUsedSearches.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error &&
        recentSearches.isEmpty &&
        mostUsedSearches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history_rounded,
                size: 48,
                color: colors.error,
              ),
              const SizedBox(height: 12),
              Text(
                'Could not load search history',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (recentSearches.isEmpty && mostUsedSearches.isEmpty) {
      return const _SearchEmptyState(
        icon: Icons.search_rounded,
        title: 'Find your next course',
        message: 'Start typing or choose a popular search.',
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        if (recentSearches.isNotEmpty) ...[
          _SuggestionHeader(
            icon: Icons.history_rounded,
            title: 'Recent searches',
          ),
          const SizedBox(height: 8),
          ...recentSearches.map(
            (query) => _SearchSuggestionTile(
              query: query,
              icon: Icons.history_rounded,
              onTap: () => onSelected(query),
              onRemove: onRemoveRecent == null
                  ? null
                  : () => onRemoveRecent!(query),
            ),
          ),
          const SizedBox(height: 22),
        ],
        if (mostUsedSearches.isNotEmpty) ...[
          _SuggestionHeader(
            icon: Icons.trending_up_rounded,
            title: 'Most used searches',
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: mostUsedSearches
                .map(
                  (query) => ActionChip(
                    avatar: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: colors.primary,
                    ),
                    label: Text(query),
                    onPressed: () => onSelected(query),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _SuggestionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SuggestionHeader({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: colors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _SearchSuggestionTile extends StatelessWidget {
  final String query;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  const _SearchSuggestionTile({
    required this.query,
    required this.icon,
    required this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: colors.onSurfaceVariant,
        ),
        title: Text(
          query,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onRemove != null)
              IconButton(
                tooltip: 'Remove from recent searches',
                onPressed: onRemove,
                icon: const Icon(Icons.close_rounded, size: 18),
              ),
            const Icon(Icons.north_west_rounded, size: 18),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

class _CourseThumbnail extends StatelessWidget {
  final String? imageUrl;

  const _CourseThumbnail({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final raw = imageUrl?.trim() ?? '';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 72,
        height: 72,
        child: raw.isEmpty
            ? _placeholder(colors)
            : Image.network(
                raw,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _placeholder(colors),
              ),
      ),
    );
  }

  Widget _placeholder(ColorScheme colors) {
    return ColoredBox(
      color: colors.primary.withValues(alpha: .10),
      child: Icon(
        Icons.menu_book_rounded,
        color: colors.primary,
        size: 30,
      ),
    );
  }
}

class _SearchEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _SearchEmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 52,
              color: colors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SearchErrorState({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: colors.error,
            ),
            const SizedBox(height: 12),
            Text(
              'Search failed',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
