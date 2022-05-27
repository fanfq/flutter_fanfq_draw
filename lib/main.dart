import 'package:flutter/material.dart';

import 'drawguess/draw_page.dart';
import 'gesture/image_gesture.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
      //ImageGesture(),
      DrawPage(),
    );
  }
}
