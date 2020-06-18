import 'package:chessroad/board/board-painter.dart';
import 'package:chessroad/board/pieces-painter.dart';
import 'package:chessroad/common/color-consts.dart';
import 'package:chessroad/game/battle.dart';
import 'package:flutter/material.dart';

import 'words-on-board.dart';

class BoardWidget extends StatelessWidget {

  static const Padding = 5.0, DigitsHeight = 36.0;  

  final double width, height;
  final Function(BuildContext, int) onBoardTap;

  BoardWidget({@required this.width, @required this.onBoardTap}):
    height = (width - Padding * 2) /9 * 10 + (Padding + DigitsHeight) * 2;

  @override 
  Widget build(BuildContext context) {
    final boardContainer = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConsts.BoardBackground
      ),
      child: CustomPaint(
        painter: BoardPainter(width: width),
        foregroundPainter: PiecesPainter(phase: Battle.shared.phase, width: width, focusIndex: Battle.shared.focusIndex, blurIndex: Battle.shared.blurIndex),
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: Padding, 
              horizontal: (width - Padding * 2) / 9 / 2 + Padding - WordsOnBoard.DigitsFontSize /2
            ),
          child: WordsOnBoard()
        ),
      )
    );

    return GestureDetector(child: boardContainer, 
      onTapUp: (detail) {
        final gridWidth = (width - Padding * 2) / 9 * 8;
        final squareSize = gridWidth / 8;

        final dx = detail.localPosition.dx, dy = detail.localPosition.dy;

        final row = (dy - Padding  - DigitsHeight) ~/ squareSize;
        final column = (dx - Padding) ~/ squareSize;
        
        if (row < 0 || row > 9) return;
        if (column < 0 || column > 8) return;

        onBoardTap(context, row*9 + column);
      });
  }

}