import 'package:flutter/material.dart';
import 'package:graduation2/Features/search/presentaion/pages/search_page.dart';

class CustomSearchWidget extends StatelessWidget {
  final TextEditingController? controller;
  final TextEditingController? con;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool readOnly;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onClear;

  const CustomSearchWidget({
    super.key,
    this.controller,
    this.con,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = true,
    this.autofocus = false,
    this.focusNode,
    this.onClear,
  });

  TextEditingController? get _effectiveController => controller ?? con;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final activeController = _effectiveController;

    if (activeController == null) {
      return _buildField(context, colors, hasText: false, controller: null);
    }

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: activeController,
      builder: (context, value, _) {
        final hasText = value.text.trim().isNotEmpty;
        return _buildField(context, colors, hasText: hasText, controller: activeController);
      },
    );
  }

  Widget _buildField(
    BuildContext context,
    ColorScheme colors, {
    required bool hasText,
    required TextEditingController? controller,
  }) {
    return TextField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          autofocus: autofocus,
          onTap: readOnly
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchPage()),
                  );
                }
              : null,
          cursorColor: colors.primary,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search courses, instructors...',
            prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
            suffixIcon: hasText
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onClear != null)
                        IconButton(
                          tooltip: 'Clear search',
                          onPressed: onClear,
                          icon: Icon(
                            Icons.close_rounded,
                            color: colors.onSurface.withValues(alpha: .60),
                          ),
                        ),
                      if (onSubmitted != null)
                        IconButton(
                          tooltip: 'Search',
                          onPressed: () => onSubmitted!(
                            controller?.text ?? '',
                          ),
                          icon: Icon(
                            Icons.search_rounded,
                            color: colors.primary,
                          ),
                        ),
                    ],
                  )
                : Icon(
                    Icons.tune_rounded,
                    color: colors.onSurface.withValues(alpha: .55),
                  ),
          ),
        );
  }
}
