import 'dart:math' as math;

import 'package:flutter/material.dart';

class SixthPage extends StatefulWidget {
  @override
  _SixthPageState createState() => _SixthPageState();
}

class _SixthPageState extends State<SixthPage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  double speed = 2;
  BlendMode blendMode = BlendMode.xor;

  @override
  void initState() {
    animationController = AnimationController(
      duration: Duration(seconds: 60),
      vsync: this,
    );

    var tween = Tween<double>(begin: -1, end: 1);
    animation = animationController.drive(tween);
    animationController.repeat();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            color: Colors.white24,
            child: AnimatedBuilder(
              animation: animation,
              builder: (_, __) => CustomPaint(
                painter: CurvePainter(
                  animation.value,
                  speed,
                  blendMode,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Slider(
            value: speed,
            min: 1,
            max: 200,
            onChanged: (value) {
              setState(() {
                speed = value;
              });
            },
          ),
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (var item in BlendMode.values)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Radio(
                          value: item,
                          groupValue: blendMode,
                          onChanged: (BlendMode value) {
                            setState(() {
                              blendMode = value;
                            });
                          },
                        ),
                        Text(item.displayTitle),
                      ],
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final double position;
  final double speed;
  final BlendMode blendMode;

  CurvePainter(this.position, this.speed, this.blendMode);

  static List<Color> colors = [
    Colors.white,
    Colors.red,
    Colors.redAccent,
    Colors.white24,
    Colors.deepOrangeAccent,
    Colors.deepPurple,
    Colors.deepOrange,
    Colors.pinkAccent,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = -20; i < 20; i++) {
      drawSin(
          size,
          canvas,
          Paint()
            ..blendMode = blendMode
            ..color = colors[(i.abs() % 8)],
          Offset(i + 0.0, 0),
          math.sin);
    }
  }

  void drawSin(Size size, Canvas canvas, Paint paint, Offset offset,
      double Function(num) calculator) {
    var path = Path();
    path..moveTo(offset.dx + (size.width / 2), offset.dy + 0);

    var values = List.generate(
        (size.height ~/ 3) + 1,
        (i) =>
            offset +
            Offset(
                size.width *
                    0.5 *
                    (1 -
                        calculator(((position + offset.distance) * speed) +
                                i / 10) *
                            0.1),
                i * 3.0));

    for (var value in values) {
      path..lineTo(value.dx - 0.5, value.dy);
    }

    for (var value in values.reversed) {
      path..lineTo(value.dx + 0.5, value.dy);
    }

    path..close();

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(CurvePainter oldDelegate) =>
      oldDelegate.position != position;
}

extension SelectedColorExtension on BlendMode {
  String get displayTitle {
    switch (this) {
      case BlendMode.clear:
        return 'clear';
        break;
      case BlendMode.src:
        return 'src';
        break;
      case BlendMode.dst:
        return 'dst';
        break;
      case BlendMode.srcOver:
        return 'srcOver';
        break;
      case BlendMode.dstOver:
        return 'dstOver';
        break;
      case BlendMode.srcIn:
        return 'srcIn';
        break;
      case BlendMode.dstIn:
        return 'dstIn';
        break;
      case BlendMode.srcOut:
        return 'srcOut';
        break;
      case BlendMode.dstOut:
        return 'dstOut';
        break;
      case BlendMode.srcATop:
        return 'srcATop';
        break;
      case BlendMode.dstATop:
        return 'dstATop';
        break;
      case BlendMode.xor:
        return 'xor';
        break;
      case BlendMode.plus:
        return 'plus';
        break;
      case BlendMode.modulate:
        return 'modulate';
        break;
      case BlendMode.screen:
        return 'screen';
        break;
      case BlendMode.overlay:
        return 'overlay';
        break;
      case BlendMode.darken:
        return 'darken';
        break;
      case BlendMode.lighten:
        return 'lighten';
        break;
      case BlendMode.colorDodge:
        return 'colorDodge';
        break;
      case BlendMode.colorBurn:
        return 'colorBurn';
        break;
      case BlendMode.hardLight:
        return 'hardLight';
        break;
      case BlendMode.softLight:
        return 'softLight';
        break;
      case BlendMode.difference:
        return 'difference';
        break;
      case BlendMode.exclusion:
        return 'exclusion';
        break;
      case BlendMode.multiply:
        return 'multiply';
        break;
      case BlendMode.hue:
        return 'hue';
        break;
      case BlendMode.saturation:
        return 'saturation';
        break;
      case BlendMode.color:
        return 'color';
        break;
      case BlendMode.luminosity:
        return 'luminosity';
        break;
    }
  }
}
