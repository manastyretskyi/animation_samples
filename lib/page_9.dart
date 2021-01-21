import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class Page9 extends StatefulWidget {
  Page9({Key key}) : super(key: key);

  @override
  _Page9State createState() => _Page9State();
}

class _Page9State extends State<Page9> {
  @override
  Widget build(BuildContext context) {
    return CardBackground();
  }
}

class CardBackground extends StatefulWidget {
  const CardBackground({
    Key key,
  }) : super(key: key);

  @override
  _CardBackgroundState createState() => _CardBackgroundState();
}

class _CardBackgroundState extends State<CardBackground>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  Animation animation;
  GlobalKey key;

  List<Point> points = [];

  Ticker ticker;

  @override
  void initState() {
    key = GlobalKey();

    // animationController =
    //     AnimationController(duration: const Duration(seconds: 10), vsync: this);

    ticker = createTicker((elapsed) {
      for (var point in points) {
        point.move(Offset(0, 1));
      }
      setState(() {});
    });

    ticker.start();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      createPoints();
    });

    // animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  void createPoints() {
    var renderBox = key.currentContext.findRenderObject() as RenderBox;
    var size = renderBox.size;

    final textStyle = TextStyle(
      color: Colors.white12,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );
    final textSpan = TextSpan(
      text: 'QWERT\nSDFG',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    var textWidth = textPainter.width;
    var textHeight = textPainter.height;

    var initialOffset = Offset(-((textWidth / 3)), -((textHeight / 3)));
    var padding = Offset(textWidth / 2, textHeight / 3);

    var columns = ((size.width ~/ textWidth) ~/ 2) + 2;
    var rows = (size.height ~/ textHeight) + 2;

    points = List.generate(rows * columns, (index) {
      var col = index ~/ columns;
      var row = index % columns;
      var colEven = col % 2 == 0;
      var o = Offset((textWidth) * (colEven ? 0 : -1), 0);
      var _p = padding.scale(row.toDouble(), col.toDouble());
      var dy = -((textHeight * 2) + _p.dy);
      var offset = o +
          initialOffset +
          Offset(
              (size.width / 4) * row, (size.width / (textHeight / 3)) * col) +
          _p +
          Offset(0, dy);
      return Point(
        position: offset,
        painter: textPainter,
        constraints: renderBox.paintBounds,
      );
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      key: key,
      painter: LogosPainer(points: points),
    );
  }
}

class Point {
  Point({
    @required this.constraints,
    @required this.position,
    @required this.painter,
  }) : original = position;

  Offset position;
  final Offset original;
  TextPainter painter;
  Rect constraints;

  double get textHeight => painter.height;
  double get textWidth => painter.width;

  void move(Offset offset) {
    var newPosition = position + offset;
    var newDx = newPosition.dx;
    var newDy = newPosition.dy;

    if (position.dy > constraints.bottom) {
      newDy = -((textHeight / 3));
    }
    if (position.dx > constraints.right) {
      newDx = -((textWidth / 3));
    }

    position = Offset(newDx, newDy);
  }
}

class LogosPainer extends CustomPainter {
  final List<Point> points;

  LogosPainer({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPaint(Paint()..color = Color(0xff1b1b1b));
    for (var point in points) {
      point.painter.paint(canvas, point.position);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
