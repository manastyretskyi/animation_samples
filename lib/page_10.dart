import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:sensors/sensors.dart';
import 'package:vector_math/vector_math.dart' hide Colors;

class Page10 extends StatefulWidget {
  const Page10({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _Page9State createState() => _Page9State();
}

class _Page9State extends State<Page10> with SingleTickerProviderStateMixin {
  DeviceRotation orientation = DeviceRotation(0, 0, 0);
  AccelerometerEvent previosEvent = AccelerometerEvent(0, 0, 0);
  Vector2 acceleration = Vector2.zero();
  Vector2 velocity;

  Alignment alignment;

  Ticker ticker;

  StreamSubscription subscription;

  @override
  void initState() {
    alignment = Alignment(0, 0);
    velocity = Vector2(0, 0);

    ticker = createTicker((t) {
      nextFrame(t);
    });

    subscription = accelerometerEvents
        .where((event) => !(nearEqual(event.x, previosEvent.x, 0.2) &&
            nearEqual(event.y, previosEvent.y, 0.2) &&
            nearEqual(event.z, previosEvent.z, 0.2)))
        .listen(onOrientationChange);
    super.initState();
  }

  void onOrientationChange(AccelerometerEvent event) {
    var newOrientation = DeviceRotation.fromAccelerometerEvent(event);
    previosEvent = event;
    orientation = newOrientation;
    if (!ticker.isActive) ticker.start();
    acceleration += Vector2((-(orientation.x / 180)) - acceleration.x,
        (orientation.y / 180) - acceleration.y);
  }

  void nextFrame(Duration time) {
    print(time);
    velocity.x += acceleration.x;
    velocity.y += acceleration.y;
    var newDx = alignment.x + velocity.x * (time.inMilliseconds + 0.1) / 1000;
    var newDy = alignment.y + velocity.y * (time.inMilliseconds + 0.1) / 1000;

    if ((velocity.x > 0 && newDx > 1) || (velocity.x < 0 && newDx < -1)) {
      acceleration.x = 0;
      velocity.x = 0;
      if (newDx < -1) {
        newDx = -1;
      } else {
        newDx = 1;
      }
    }

    if ((velocity.y > 0 && newDy > 1) || (velocity.y < 0 && newDy < -1)) {
      acceleration.y = 0;
      velocity.y = 0;
      if (newDy < -1) {
        newDy = -1;
      } else {
        newDy = 1;
      }
    }

    var newAlignment = Alignment(newDx, newDy);
    if (newAlignment == alignment) ticker.stop();

    setState(() {
      alignment = newAlignment;
    });
  }

  void animate() {}

  @override
  dispose() {
    subscription.cancel();
    ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: alignment,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            width: MediaQuery.of(context).size.width * 0.8,
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

class DeviceRotation {
  Vector3 rotation;

  DeviceRotation(double x, double y, double z)
      : this.rotation = Vector3(x, y, z);

  DeviceRotation.vertor3({this.rotation});

  DeviceRotation.fromAccelerometerEvent(AccelerometerEvent event) {
    double x = event.x, y = event.y, z = event.z;
    double normOfG =
        math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    x = event.x / normOfG;
    y = event.y / normOfG;
    z = event.z / normOfG;

    double xInclination =
        math.atan(x / math.sqrt(y * y + z * z)) * (180 / math.pi);
    double yInclination =
        math.atan(y / math.sqrt(x * x + z * z)) * (180 / math.pi);
    double zInclination =
        math.atan(z / math.sqrt(y * y + x * x)) * (180 / math.pi);

    rotation = Vector3(xInclination, yInclination, zInclination);
  }

  bool get isFaceUp => rotation.z > 0;
  bool get isLying => rotation.z.abs() > 75;
  bool get isPortraitUp => rotation.y > 25;
  bool get isPortraitDown => rotation.y < -25;
  bool get isLandscapeLeft => rotation.x > 25;
  bool get isLandscapeRigth => rotation.x < -25;

  double get x => rotation.x;
  double get y => rotation.y;
  double get z => rotation.z;
}
