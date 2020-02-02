library neu_material;

import 'dart:math';

import 'package:flutter/material.dart';

enum SurfaceCurve {
  concave,
  convex,
  flat,
}

class NeuMaterial extends StatelessWidget {
  const NeuMaterial({
    Key key,
    this.surfaceCurve = SurfaceCurve.flat,
    this.blur = 8.0,
    this.elevation = const Offset(3, 3),
    this.color,
    this.colorFactor = 1.05,
    this.shadowFactor = 1.1,
    this.spread = 0.0,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.clipBehavior = Clip.none,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.borderSide,
    @required this.duration,
    this.child,
  })  : assert(shape != null),
        assert(duration != null),
        super(key: key);

  final SurfaceCurve surfaceCurve;
  final double blur;
  final double spread;
  final Offset elevation;
  final Color color;
  final double colorFactor;
  final double shadowFactor;
  final BorderRadius borderRadius;
  final BoxShape shape;
  final Clip clipBehavior;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BorderSide borderSide;
  final Duration duration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).primaryColor;
    final materialLight = color.brighten(colorFactor);
    final materialDark = color.darken(colorFactor);
    final shadowLight = colorFactor == shadowFactor
        ? materialLight
        : color.brighten(shadowFactor);
    final shadowDark =
        colorFactor == shadowFactor ? materialDark : color.darken(shadowFactor);

    Gradient gradient;
    if (surfaceCurve != SurfaceCurve.flat) {
      gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: surfaceCurve == SurfaceCurve.concave
            ? [materialLight, materialDark]
            : [materialDark, materialLight],
      );
    }

    return Padding(
      padding: padding,
      child: AnimatedContainer(
        duration: duration,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          shape: shape,
          gradient: gradient,
          border: Border.fromBorderSide(borderSide ?? BorderSide.none),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: shadowLight,
              offset: -elevation,
              blurRadius: blur,
              spreadRadius: spread,
            ),
            BoxShadow(
              color: shadowDark,
              offset: elevation,
              blurRadius: blur,
              spreadRadius: spread,
            ),
          ],
        ),
        child: Padding(
          padding: margin,
          child: child,
        ),
      ),
    );
  }
}

extension on Color {
  static const int kThreshold = 255;

  Color brighten(double factor) {
    final r = (this.red * factor).toInt();
    final g = (this.green * factor).toInt();
    final b = (this.blue * factor).toInt();
    final maxComponent = max(r, max(g, b));
    if (maxComponent <= kThreshold) {
      return Color.fromARGB(255, r, g, b);
    }
    final total = r + g + b;
    if (total >= 3 * kThreshold) {
      return Colors.white;
    }
    final x = (3 * kThreshold - total) / (3 * maxComponent - total);
    final gray = kThreshold - x * maxComponent;
    return Color.fromARGB(
      255,
      (gray + x * r).toInt(),
      (gray + x * g).toInt(),
      (gray + x * b).toInt(),
    );
  }

  Color darken(double factor) {
    return this.brighten(1 / factor);
  }
}
