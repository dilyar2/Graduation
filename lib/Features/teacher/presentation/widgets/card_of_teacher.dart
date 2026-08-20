import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CardOfTeacher extends StatelessWidget {
  final int id;
  final String firstName;
  final String lastName;
  final String specialization;
  final double rating;
  final String bio;
  final int views;
  final Uint8List image;
  final VoidCallback? onTap;

  const CardOfTeacher({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.specialization,
    required this.rating,
    required this.bio,
    required this.views,
    required this.image,
    required this.onTap,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasImage = image.isNotEmpty;
    return SizedBox(
      width: 170,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: colors.primary.withValues(alpha: .12),
                  backgroundImage: hasImage ? MemoryImage(image) : null,
                  child: hasImage
                      ? null
                      : Icon(Icons.person_outline, color: colors.primary, size: 32),
                ),
                const SizedBox(height: 10),
                Text(
                  '$firstName $lastName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialization,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star_rounded, color: colors.secondary, size: 17),
                    const SizedBox(width: 4),
                    Text(rating.toStringAsFixed(1), style: Theme.of(context).textTheme.labelLarge),
                    const SizedBox(width: 10),
                    Icon(Icons.visibility_outlined, color: colors.primary, size: 16),
                    const SizedBox(width: 3),
                    Text('$views', style: Theme.of(context).textTheme.labelSmall),
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
