import 'package:flutter/material.dart';

class CustomCourseCard extends StatelessWidget {
  const CustomCourseCard({
    super.key,
    this.onTap,
    required this.image,
    required this.courseName,
    required this.description,
    required this.rating,
    required this.watchCount,
    required this.title,
    this.price,
  });

  final VoidCallback? onTap;
  final String? image;
  final String courseName;
  final String title;
  final String description;
  final double rating;
  final int watchCount;
  final double? price;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return SizedBox(
      width: 280,
      child: Card(
      margin: EdgeInsets.zero,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colors.primary.withValues(alpha: .28)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 110,
                width: double.infinity,
                child: image != null && image!.trim().isNotEmpty
                    ? Image.network(
                        image!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                      )
                    : const _ImagePlaceholder(),
              ),
              const SizedBox(height: 10),
              Text(
                courseName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.bodySmall,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: text.titleMedium,
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: text.bodySmall,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: colors.secondary, size: 16),
                  const SizedBox(width: 4),
                  Text(rating.toStringAsFixed(1), style: text.bodySmall),
                  const SizedBox(width: 12),
                  Icon(Icons.visibility_outlined,
                      color: colors.onSurface.withValues(alpha: .55), size: 16),
                  const SizedBox(width: 4),
                  Text('$watchCount', style: text.bodySmall),
                  const Spacer(),
                  if (price != null)
                    Text(
                      price!.toStringAsFixed(2),
                      style: text.titleSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      color: colors.onSurface.withValues(alpha: .06),
      child: Center(
        child: Icon(
          Icons.menu_book,
          size: 42,
          color: colors.primary.withValues(alpha: .7),
        ),
      ),
    );
  }
}
