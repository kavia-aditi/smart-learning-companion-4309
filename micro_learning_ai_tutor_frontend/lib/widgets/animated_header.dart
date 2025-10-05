import 'package:flutter/material.dart';

/// PUBLIC_INTERFACE
class AnimatedHeader extends StatefulWidget {
  /// Title text displayed in the header.
  final String title;

  /// Enable or disable animation. When disabled, renders static header.
  final bool enableAnimation;

  /// Controls the speed of the ambient animations. 1.0 is default. Higher is faster.
  final double speedFactor;

  /// Optional height of the header area.
  final double height;

  /// Whether to show the CTA button.
  final bool showCta;

  /// Label for the CTA button. Defaults to 'Start Learning'.
  final String ctaLabel;

  /// Optional icon for the CTA button.
  final IconData? ctaIcon;

  /// Callback invoked when CTA is pressed. If null, button is disabled.
  final VoidCallback? onCtaPressed;

  const AnimatedHeader({
    super.key,
    required this.title,
    this.enableAnimation = true,
    this.speedFactor = 1.0,
    this.height = 200,
    this.showCta = true,
    this.ctaLabel = 'Start Learning',
    this.ctaIcon,
    this.onCtaPressed,
  });

  @override
  State<AnimatedHeader> createState() => _AnimatedHeaderState();
}

class _AnimatedHeaderState extends State<AnimatedHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;
  late final Animation<double> _drift;

  // Ocean Professional theme colors
  // Primary: #2563EB (blue-600)
  // Secondary/Accent: #F59E0B (amber-500)
  // Background: #f9fafb (gray-50)
  static const Color _primaryBlue = Color(0xFF2563EB);
  static const Color _bgGray50 = Color(0xFFF9FAFB);

  @override
  void initState() {
    super.initState();

    // Use a subtle looped animation for header elements
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        // Base 3200ms loop, adjusted by speed factor
        milliseconds: (3200 ~/ widget.speedFactor.clamp(0.2, 3.0)).toInt(),
      ),
    );

    // Pulse for the title scale 0.98 <-> 1.0
    _pulse = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.98, end: 1.0), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.98), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Drift value 0.0 <-> 1.0 for offset/opacity modulation
    _drift = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update duration if speed factor changes
    if (oldWidget.speedFactor != widget.speedFactor) {
      _controller.duration = Duration(
        milliseconds: (3200 ~/ widget.speedFactor.clamp(0.2, 3.0)).toInt(),
      );
      if (widget.enableAnimation) {
        _controller
          ..reset()
          ..repeat(reverse: true);
      }
    }

    // Start/stop the animation based on enable flag
    if (oldWidget.enableAnimation != widget.enableAnimation) {
      if (widget.enableAnimation) {
        _controller
          ..reset()
          ..repeat(reverse: true);
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  LinearGradient _buildHeaderGradient() {
    // Gradient: primary blue to gray-50 to align with style guide
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[
        _primaryBlue,
        _bgGray50,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = widget.height;
    final cs = Theme.of(context).colorScheme;

    // Static render when animation disabled
    if (!widget.enableAnimation) {
      return Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: _buildHeaderGradient(),
        ),
        child: _HeaderContent(
          title: widget.title,
          showCta: widget.showCta,
          ctaLabel: widget.ctaLabel,
          ctaIcon: widget.ctaIcon,
          onCtaPressed: widget.onCtaPressed,
          primaryColor: cs.primary,
          accentColor: const Color(0xFFF59E0B),
          textColor: const Color(0xFF111827),
        ),
      );
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // Subtle horizontal drift for the amber accent circle
          final double dx = (MediaQuery.of(context).size.width * 0.05) *
              // Map drift 0..1 to -1..1 then multiply
              (2 * _drift.value - 1);

          // Subtle vertical drift
          final double dy = 6 * (2 * (1 - _drift.value) - 1);

          // Opacity modulation 0.12..0.18
          final double accentOpacity =
              0.12 + 0.06 * (0.5 + 0.5 * (2 * _drift.value - 1).abs());

          return Container(
            decoration: BoxDecoration(
              gradient: _buildHeaderGradient(),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                // Decorative amber circle - very subtle and soft
                Positioned(
                  right: MediaQuery.of(context).size.width * 0.15 + dx,
                  top: height * 0.15 + dy,
                  child: _AmbientCircle(
                    diameter: height * 0.7,
                    color: const Color(0xFFF59E0B).withAlpha(
                        (accentOpacity.clamp(0.0, 1.0) * 255).toInt()),
                  ),
                ),
                // Light blue blur circle on left for depth
                Positioned(
                  left: MediaQuery.of(context).size.width * 0.05 - dx * 0.6,
                  bottom: height * 0.10 - dy * 0.5,
                  child: _AmbientCircle(
                    diameter: height * 0.5,
                    color: _primaryBlue.withAlpha(28), // ~0.11 opacity
                  ),
                ),

                // Title + CTA content area
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Transform.scale(
                      scale: _pulse.value,
                      child: _HeaderContent(
                        title: widget.title,
                        showCta: widget.showCta,
                        ctaLabel: widget.ctaLabel,
                        ctaIcon: widget.ctaIcon,
                        onCtaPressed: widget.onCtaPressed,
                        primaryColor: cs.primary,
                        accentColor: const Color(0xFFF59E0B),
                        textColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AmbientCircle extends StatelessWidget {
  final double diameter;
  final Color color;

  const _AmbientCircle({
    required this.diameter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        // Soft blur using shadow for subtle glow
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: diameter * 0.25,
            spreadRadius: diameter * 0.05,
          ),
        ],
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  final String title;
  final bool showCta;
  final String ctaLabel;
  final IconData? ctaIcon;
  final VoidCallback? onCtaPressed;
  final Color primaryColor;
  final Color accentColor;
  final Color textColor;

  const _HeaderContent({
    required this.title,
    required this.showCta,
    required this.ctaLabel,
    required this.ctaIcon,
    required this.onCtaPressed,
    required this.primaryColor,
    required this.accentColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive layout: title and CTA in a row; CTA wraps on small widths.
    return Semantics(
      header: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Expanded title to prevent overflow
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: textColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (showCta)
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: ElevatedButton.icon(
                  icon: Icon(ctaIcon ?? Icons.play_arrow_rounded, size: 22),
                  onPressed: onCtaPressed,
                  label: Text(
                    ctaLabel,
                    // Ensure accessible sizing
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor, // #2563EB
                    foregroundColor: Colors.white,
                    elevation: 1,
                    minimumSize: const Size(0, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ).merge(
                    ButtonStyle(
                      overlayColor: WidgetStateProperty.resolveWith(
                        (states) {
                          if (states.contains(WidgetState.pressed) ||
                              states.contains(WidgetState.hovered) ||
                              states.contains(WidgetState.focused)) {
                            // Amber accent for interaction feedback
                            return accentColor.withAlpha(40);
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
