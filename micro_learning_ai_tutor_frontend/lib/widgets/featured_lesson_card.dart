import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class FeaturedLessonCard extends StatelessWidget {
  /// Gradient "Continue Learning" hero card with optional illustration.
  const FeaturedLessonCard({
    super.key,
    this.title = 'Continue Learning',
    this.onTap,
    this.height = 140,
    this.illustrationAsset = 'assets/illust_continue_learning.png',
  });

  final String title;
  final VoidCallback? onTap;
  final double height;
  final String illustrationAsset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF2D7CF6),
        Color(0xFF4FA2FF),
      ],
    );

    return Semantics(
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          height: height,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25), // ~0.10
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text block
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Illustration
                Hero(
                  tag: 'continue-illustration',
                  child: Image.asset(
                    illustrationAsset,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stack) {
                      // Fallback icon if asset missing
                      return const Icon(Icons.play_circle_fill, color: Colors.white, size: 56);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
