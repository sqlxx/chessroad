import 'package:chessroad/routes/battle-page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ChessRoadApp());
}

class ChessRoadApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.brown,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BattlePage()
    );
  }
}