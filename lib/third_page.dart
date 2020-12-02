import 'package:flutter/material.dart';

class ThirdPage extends StatefulWidget {
  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );

    animation = TweenSequence<Color>([
      TweenSequenceItem<Color>(
        weight: 10,
        tween: ColorTween(
          begin: Colors.red,
          end: Colors.blue,
        ),
      ),
      TweenSequenceItem<Color>(
        weight: 10,
        tween: ColorTween(
          begin: Colors.blue,
          end: Colors.amber,
        ),
      ),
      TweenSequenceItem<Color>(
        weight: 10,
        tween: ColorTween(
          begin: Colors.amber,
          end: Colors.pink,
        ),
      ),
      TweenSequenceItem<Color>(
        weight: 10,
        tween: ColorTween(
          begin: Colors.pink,
          end: Colors.purple,
        ),
      ),
      TweenSequenceItem<Color>(
        weight: 10,
        tween: ColorTween(
          begin: Colors.purple,
          end: Colors.green,
        ),
      ),
      TweenSequenceItem<Color>(
        weight: 10,
        tween: ColorTween(
          begin: Colors.green,
          end: Colors.yellow,
        ),
      ),
      TweenSequenceItem<Color>(
        weight: 10,
        tween: ColorTween(
          begin: Colors.yellow,
          end: Colors.grey,
        ),
      ),
      TweenSequenceItem<Color>(
        weight: 10,
        tween: ColorTween(
          begin: Colors.grey,
          end: Colors.indigo,
        ),
      ),
      TweenSequenceItem<Color>(
        weight: 10,
        tween: ColorTween(
          begin: Colors.indigo,
          end: Colors.pinkAccent,
        ),
      ),
      TweenSequenceItem<Color>(
        weight: 10,
        tween: ColorTween(
          begin: Colors.pinkAccent,
          end: Colors.red,
        ),
      ),
    ]).animate(_animationController);

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) {
        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            child: Text(
              "Color Animation",
              style: TextStyle(fontSize: 32, color: animation.value),
            ),
          ),
        );
        // return Scaffold(
        //   body: Container(
        //     child: ShaderMask(
        //       shaderCallback: (Rect bounds) => RadialGradient(
        //         center: Alignment.center,
        //         radius: 1,
        //         tileMode: TileMode.mirror,
        //         colors: [Colors.white, Colors.red],
        //       ).createShader(bounds),
        //       child: Text(
        //         "Color Animation",
        //         style: TextStyle(fontSize: 32, color: Colors.white),
        //       ),
        //     ),
        //   ),
        // );
      },
    );
  }
}
