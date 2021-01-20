import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class IconController extends RiveAnimationController<RuntimeArtboard> {
  CustomLinearAnimationInstance _instance;
  final String animationName;
  final bool initialAtEnd;
  IconController(this.animationName, this.initialAtEnd);

  CustomLinearAnimationInstance get instance => _instance;

  void go() {
    isActive = true;
  }

  void forvard() {
    _instance.time = 0;
    _instance.direction = 1;
    go();
  }

  void backaward() {
    _instance.time = (_instance.animation.duration / _instance.animation.fps);
    _instance.direction = -1;
    go();
  }

  bool get onEnd {
    return _instance.time ==
        (_instance.animation.duration / _instance.animation.fps);
  }

  @override
  bool init(RuntimeArtboard artboard) {
    var animation = artboard.animations.firstWhere(
      (animation) =>
          animation is LinearAnimation && animation.name == animationName,
      orElse: () => null,
    );
    if (animation != null) {
      _instance = CustomLinearAnimationInstance(animation as LinearAnimation);
    }
    if (initialAtEnd) {
      _instance.time = _instance.animation.duration.toDouble();
      _instance.direction = 1;
    } else {
      _instance.time = 0;
      _instance.direction = -1;
    }
    isActive = true;
    return _instance != null;
  }

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    _instance.animation.apply(_instance.time, coreContext: artboard);
    if (!_instance.advance(elapsedSeconds, stopOnChange: true)) {
      isActive = false;
    }
  }
}

class CustomLinearAnimationInstance {
  final LinearAnimation animation;
  double _time = 0;
  int direction = 1;
  CustomLinearAnimationInstance(this.animation)
      : _time =
            (animation.enableWorkArea ? animation.workStart : 0).toDouble() /
                animation.fps;
  double get time => _time;
  set time(double value) {
    if (_time == value) {
      return;
    }
    _time = value;
    // direction = 1;
  }

  bool advance(double elapsedSeconds, {bool stopOnChange = false}) {
    _time += elapsedSeconds * animation.speed * direction;
    double frames = _time * animation.fps;
    var start = animation.enableWorkArea ? animation.workStart : 0;
    var end = animation.enableWorkArea ? animation.workEnd : animation.duration;
    var range = end - start;
    bool keepGoing = true;
    switch (animation.loop) {
      case Loop.oneShot:
        if (frames > end) {
          keepGoing = false;
          frames = end.toDouble();
          _time = frames / animation.fps;
        }
        break;
      case Loop.loop:
        if (frames >= end) {
          frames = _time * animation.fps;
          frames = start + (frames - start) % range;
          _time = frames / animation.fps;
          keepGoing = !stopOnChange;
        }
        break;
      case Loop.pingPong:
        while (true) {
          if (direction == 1 && frames >= end) {
            direction = -1;
            frames = end + (end - frames);
            _time = frames / animation.fps;
            keepGoing = !stopOnChange;
          } else if (direction == -1 && frames < start) {
            direction = 1;
            frames = start + (start - frames);
            _time = frames / animation.fps;
            keepGoing = !stopOnChange;
          } else {
            break;
          }
        }
        break;
    }
    return keepGoing;
  }
}

class SeventhPage extends StatefulWidget {
  SeventhPage({Key key}) : super(key: key);

  @override
  _SeventhPageState createState() => _SeventhPageState();
}

class _SeventhPageState extends State<SeventhPage> {
  void _togglePlay() {
    if (_controller.onEnd) {
      _controller.backaward();
    } else {
      _controller.forvard();
    }
    setState(() {});
  }

  bool get isPlaying => false;

  Artboard _riveArtboard;
  IconController _controller;
  @override
  void initState() {
    super.initState();

    rootBundle.load('assets/heart.riv').then(
      (data) async {
        final file = RiveFile();

        if (file.import(data)) {
          final artboard = file.mainArtboard;

          artboard
              .addController(_controller = IconController('trim_path', true));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _riveArtboard == null
            ? const SizedBox()
            : Rive(artboard: _riveArtboard, fit: BoxFit.cover),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlay,
        tooltip: isPlaying ? 'Pause' : 'Play',
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
