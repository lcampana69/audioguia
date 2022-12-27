
import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  final Widget w;
  AnimatedText(this.w);
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText>
    with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      lowerBound: 0.2,
      upperBound: 1.0,
      vsync: this,
    )..repeat(reverse:true);
    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  FadeTransition(
          opacity: _animation,
          child: widget.w
          );
  }
}
