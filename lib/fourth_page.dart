import 'package:flutter/material.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({Key key}) : super(key: key);

  @override
  _FourthPageState createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  PageController _controller;
  int _currentPage;
  bool _pageHasChanged = false;
  final items = [
    Container(
      color: Colors.pinkAccent,
    ),
    Container(
      color: Colors.amberAccent,
    ),
    Container(
      color: Colors.greenAccent,
    )
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _controller = PageController(
      viewportFraction: .65,
      initialPage: _currentPage,
    );
  }

  @override
  Widget build(context) {
    return PageView.builder(
      onPageChanged: (value) {
        setState(() {
          _pageHasChanged = true;
          _currentPage = value;
        });
      },
      controller: _controller,
      itemBuilder: (context, index) => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          var result = _pageHasChanged ? _controller.page : _currentPage;
          var value = result - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);

          return Center(
            child: SizedBox(
              height: Curves.easeOut.transform(value) * 300,
              width: Curves.easeOut.transform(value) * 300,
              child: child,
            ),
          );
        },
        child: items[index % items.length],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
