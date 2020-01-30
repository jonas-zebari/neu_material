library neu_material;

import 'dart:math';

import 'package:flutter/material.dart';

enum NeuMaterialType {
  concave,
  convex,
  flat,
}

class NeuMaterial extends StatelessWidget {
  const NeuMaterial({
    Key key,
    this.type = NeuMaterialType.flat,
    this.elevation = 8.0,
    this.offset = const Offset(3, 3),
    this.color,
    this.colorFactor = 1.05,
    double shadowFactor = 1.1,
    this.invertShadow = false,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.clipBehavior = Clip.none,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.child,
  })  : shadowFactor = shadowFactor ?? colorFactor,
        assert(shape != null),
        super(key: key);

  final NeuMaterialType type;
  final double elevation;
  final Offset offset;
  final Color color;
  final double colorFactor;
  final double shadowFactor;
  final bool invertShadow;
  final BorderRadius borderRadius;
  final BoxShape shape;
  final Clip clipBehavior;
  final EdgeInsets margin;
  final EdgeInsets padding;
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
    switch (type) {
      case NeuMaterialType.concave:
        gradient = RadialGradient(
          radius: 1.0,
          colors: <Color>[
            materialLight,
            materialDark,
          ],
        );
        break;
      case NeuMaterialType.convex:
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            materialDark,
            materialLight,
          ],
        );
        break;
      default:
    }

    return Padding(
      padding: padding,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          shape: shape,
          gradient: gradient,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: shadowLight,
              offset: -offset,
              blurRadius: elevation,
            ),
            BoxShadow(
              color: shadowDark,
              offset: offset,
              blurRadius: elevation,
            ),
          ],
        ),
        position: invertShadow
            ? DecorationPosition.foreground
            : DecorationPosition.background,
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
