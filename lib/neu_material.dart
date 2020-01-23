library neu_material;

import 'dart:math';

import 'package:flutter/material.dart';

enum NeuMaterialType {
  concave,
  convex,
  flat,
}

enum NeuSelectedType {
  static,
  lowered,
  inverted,
}

class NeuMaterial extends StatefulWidget {
  const NeuMaterial({
    Key key,
    this.type = NeuMaterialType.flat,
    this.selectedType = NeuSelectedType.inverted,
    this.elevation = 12.0,
    this.offset = const Offset(6, 6),
    this.color = const Color(0xFFDCDCDC),
    this.colorFactor = 1.05,
    this.borderRadius,
    this.shape,
    this.clipBehavior = Clip.none,
    this.animationDuration = const Duration(milliseconds: 100),
    this.animationCurve = Curves.linear,
    this.child,
  }) : super(key: key);

  final NeuMaterialType type;
  final NeuSelectedType selectedType;
  final double elevation;
  final Offset offset;
  final Color color;
  final double colorFactor;
  final BorderRadius borderRadius;
  final BoxShape shape;
  final Clip clipBehavior;
  final Duration animationDuration;
  final Curve animationCurve;
  final Widget child;

  @override
  _NeuMaterialState createState() => _NeuMaterialState();
}

class _NeuMaterialState extends State<NeuMaterial>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<BoxDecoration> _decoration;

  DecorationPosition get _decorationPosition {
    return widget.selectedType == NeuSelectedType.inverted &&
            _controller.value > 0.5
        ? DecorationPosition.foreground
        : DecorationPosition.background;
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedType != NeuSelectedType.static) {
      _controller = AnimationController(
        vsync: this,
        duration: widget.animationDuration,
      );
      final elevation = widget.elevation;
      final light = widget.color.brighten(widget.colorFactor);
      final dark = widget.color.darken(widget.colorFactor);
      Gradient gradient;
      switch (widget.type) {
        case NeuMaterialType.concave:
          gradient = RadialGradient(
            radius: 1.0,
            colors: <Color>[light, dark],
          );
          break;
        case NeuMaterialType.convex:
          gradient = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[dark, light],
          );
          break;
        default:
      }
      final startLightShadow = BoxShadow(
        color: light,
        offset: -widget.offset,
        blurRadius: elevation,
      );
      final startDarkShadow = BoxShadow(
        color: dark,
        offset: widget.offset,
        blurRadius: elevation,
      );
      Offset endOffset;
      double endSpread, endBlur;
      if (widget.selectedType != NeuSelectedType.static) {
        switch (widget.selectedType) {
          case NeuSelectedType.lowered:
            endOffset = widget.offset / 3;
            endSpread = 0.0;
            endBlur = elevation;
            break;
          case NeuSelectedType.inverted:
            endOffset = Offset.zero;
            endSpread = -elevation;
            endBlur = elevation;
            break;
          default:
        }
      }
      final beginningDecoration = BoxDecoration(
        color: widget.color,
        borderRadius: widget.borderRadius,
        shape: widget.shape,
        gradient: gradient,
        boxShadow: <BoxShadow>[
          startLightShadow,
          startDarkShadow,
        ],
      );
      final endDecoration = beginningDecoration.copyWith(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: light,
            offset: endOffset,
            spreadRadius: endSpread,
            blurRadius: endBlur,
          ),
          BoxShadow(
            color: dark,
            offset: endOffset,
            spreadRadius: endSpread,
            blurRadius: endBlur,
          ),
        ],
      );
      _decoration = Tween<BoxDecoration>(
        begin: beginningDecoration,
        end: endDecoration,
      ).animate(CurvedAnimation(
        curve: widget.animationCurve,
        parent: _controller,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBoxTransition(
      decoration: _decoration,
      position: _decorationPosition,
      child: widget.child,
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
