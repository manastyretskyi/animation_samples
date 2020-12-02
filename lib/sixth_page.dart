import 'dart:math';

import 'package:flutter/material.dart';

class SixthPage extends StatefulWidget {
  @override
  _SixthPageState createState() => _SixthPageState();
}

class _SixthPageState extends State<SixthPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );

    animationController.repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: 300,
          height: 300,
          color: Colors.amberAccent,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (_, __) => CustomPaint(
              painter: CurvePainter(animationController.value),
            ),
          ),
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final double position;

  CurvePainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    var prev;

    for (var i = 0; i < size.height / 3; i++) {
      var start = Offset(
          size.width *
              0.5 *
              (1 - sin(((0.5 - position).abs() * 30) + i / 10) * 0.1),
          i * 3.0);
      if (prev != null) {
        canvas.drawLine(
          prev,
          start,
          Paint()
            ..color = Colors.amber
            ..strokeWidth = 3,
        );
      }
      prev = start;
    }

    canvas.drawLine(
      prev,
      Offset(prev.dx, prev.dy + 3),
      Paint()
        ..color = Colors.amber
        ..strokeWidth = 3,
    );
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) =>
      oldDelegate.position != position;
}
