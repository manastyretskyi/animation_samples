import 'package:animation_samples/eighth_page.dart';
import 'package:animation_samples/fifth_page.dart';
import 'package:animation_samples/first_page.dart';
import 'package:animation_samples/fourth_page.dart';
import 'package:animation_samples/page_10.dart';
import 'package:animation_samples/page_9.dart';
import 'package:animation_samples/second_page.dart';
import 'package:animation_samples/seventh_page.dart';
import 'package:animation_samples/sixth_page.dart';
import 'package:animation_samples/third_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = PageController(initialPage: 9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [
          FirstPage(),
          SecondPage(),
          ThirdPage(),
          FourthPage(),
          FifthPage(),
          SixthPage(),
          SeventhPage(),
          EighthPage(),
          Page9(),
          Page10(
            child: RotatedBox(
              quarterTurns: 3,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: Icon(Icons.arrow_back),
            onPressed: () {
              controller.previousPage(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 500),
              );
            },
          ),
          Container(
            width: 10,
            height: 0,
          ),
          FloatingActionButton(
            child: Icon(Icons.arrow_forward),
            onPressed: () {
              controller.nextPage(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 500),
              );
            },
          )
        ],
      ),
    );
  }
}
