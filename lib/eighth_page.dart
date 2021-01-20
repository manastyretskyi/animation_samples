import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class EighthPage extends StatefulWidget {
  EighthPage({Key key}) : super(key: key);

  @override
  _EighthPageState createState() => _EighthPageState();
}

class _EighthPageState extends State<EighthPage> {
  Artboard artboard;
  RiveAnimationController _controller;

  void _togglePlay() {
    setState(() => _controller.isActive = !_controller.isActive);
  }

  bool get isPlaying => _controller?.isActive ?? false;

  @override
  void initState() {
    rootBundle.load('assets/sample.riv').then((data) {
      var file = RiveFile();
      file.import(data);

      setState(() {
        artboard = file.mainArtboard;
        artboard.addController(_controller = SimpleAnimation('water'));
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: artboard == null
            ? const SizedBox()
            : Rive(artboard: artboard, fit: BoxFit.contain),
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
