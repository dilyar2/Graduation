import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title, description;

  const SectionCard({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(description, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
