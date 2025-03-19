import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class PawLoading extends StatefulWidget {
  @override
  _PawLoadingState createState() => _PawLoadingState();
}

class _PawLoadingState extends State<PawLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: ScaleTransition(
        scale: _animation,
        child: Image.asset('assets/paw.png', width: 60, height: 60), // Add a paw image in assets
      ),
    );
  }
}
