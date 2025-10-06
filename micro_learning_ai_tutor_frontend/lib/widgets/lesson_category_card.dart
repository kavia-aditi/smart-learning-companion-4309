import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class LessonCategoryCard extends StatefulWidget {
  /// A category card tile with background color, leading circular icon, and title.
  /// Matches Ocean Professional rounded/elevated card style.
  const LessonCategoryCard({
    super.key,
    required this.title,
    required this.backgroundColor,
    required this.icon,
    required this.textColor,
    this.onTap,
  });

  final String title;
  final Color backgroundColor;
  final IconData icon;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  State<LessonCategoryCard> createState() => _LessonCategoryCardState();
}

class _LessonCategoryCardState extends State<LessonCategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final double scale = _pressed ? 0.98 : 1.0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: scale,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25), // ~0.10 opacity
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(230),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 24,
                  color: widget.textColor.withAlpha(230),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: widget.textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
