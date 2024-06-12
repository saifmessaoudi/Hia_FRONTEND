import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Color color;
  final double size;
  final double spacing;

  const LoadingWidget({
    Key? key,
    this.color = Colors.grey,
    this.size = 20.0,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Dot(color: color, size: size),
        SizedBox(width: spacing),
        Dot(color: color, size: size),
        SizedBox(width: spacing),
        Dot(color: color, size: size),
      ],
    );
  }
}

class Dot extends StatefulWidget {
  final Color color;
  final double size;

  const Dot({
    Key? key,
    required this.color,
    required this.size,
  }) : super(key: key);

  @override
  _DotState createState() => _DotState();
}

class _DotState extends State<Dot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat();
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
