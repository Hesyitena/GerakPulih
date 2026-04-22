import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gerakpulih_flutter/core/theme.dart';

/// Reusable frosted glass card widget
class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double blur;
  final VoidCallback? onTap;
  final bool elevated;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = AppTheme.rXl,
    this.padding,
    this.color,
    this.blur = 28,
    this.onTap,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Colors.white.withOpacity(0.75);
    final shadows = elevated ? AppTheme.shadowMd : AppTheme.shadowSm;

    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
            boxShadow: [
              ...shadows,
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                blurRadius: 0,
                spreadRadius: 0,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 150),
          child: card,
        ),
      );
    }

    return card;
  }
}
