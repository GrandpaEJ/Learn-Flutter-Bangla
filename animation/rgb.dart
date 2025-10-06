import 'package:flutter/material.dart';

class RgbText extends StatefulWidget {
  final String text;
  final Duration duration;
  final TextStyle? style;

  const RgbText(
    this.text,
    this.duration, {
    Key? key,
    this.style,
  }) : super(key: key);

  @override
  _RgbTextState createState() => _RgbTextState();
}

class _RgbTextState extends State<RgbText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.green),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.green, end: Colors.blue),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.blue, end: Colors.red),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        final userStyle = widget.style ?? const TextStyle();
        final animatedStyle = userStyle.copyWith(color: _colorAnimation.value);

        return Text(
          widget.text,
          style: animatedStyle,
        );
      },
    );
  }
}
