import 'package:chessroad/board/board-widget.dart';
import 'package:flutter/material.dart';

class BattlePage extends StatelessWidget {
  static const BoardMarginV = 10.0, BoardMarginH = 10.0;

  @override
  Widget build(BuildContext context) {
    final windowSize = MediaQuery.of(context).size;
    final boardHeight = windowSize.width - BoardMarginH * 2;

    return Scaffold(
      appBar: AppBar(title: Text('Battle')),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: BoardMarginH, vertical: BoardMarginV),
        child: BoardWidget(width: boardHeight)
      ),
    );
  }
}