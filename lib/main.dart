import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'routes/main-menu.dart';

void main() {
  runApp(ChessRoadApp());

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
  }

  SystemChrome.setEnabledSystemUIOverlays([]);
}

class ChessRoadApp extends StatelessWidget {
  static const StatusBarHeight = 28.0;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Pinru',
      ),
      home: MainMenu()
    );
  }
}