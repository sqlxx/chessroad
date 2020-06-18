import 'package:chessroad/board/board-widget.dart';
import 'package:chessroad/common/color-consts.dart';
import 'package:flutter/material.dart';

import 'painter-base.dart';

class BoardPainter extends PainterBase {
  final double width;
  final thePaint = Paint();

  BoardPainter({@required this.width}) : super(width: width);
    
  @override
  void paint(Canvas canvas, Size size) {
    doPaint(canvas, thePaint, gridWidth, squareSize, BoardWidget.Padding + squareSize/2, BoardWidget.Padding + BoardWidget.DigitsHeight + squareSize/2);
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

  static doPaint(Canvas canvas, Paint paint, double gridWidth, double squareSize, double offsetX, double offsetY) {
    paint.color = ColorConsts.BoardLine;
    paint.style = PaintingStyle.stroke;

    var left = offsetX, top = offsetY;

    paint.strokeWidth = 2;
    canvas.drawRect(Rect.fromLTWH(left, top, gridWidth, squareSize * 9), paint);

    paint.strokeWidth = 1;

    for (var i = 1; i < 9; i ++) {
      canvas.drawLine(
        Offset(left, top + squareSize * i),
        Offset(left + gridWidth, top + squareSize * i),
        paint
      );
    }

    for (var i = 1; i < 8; i ++) {
      
      canvas.drawLine(Offset(left + squareSize * i, top), Offset(left + squareSize * i, top + squareSize * 4), paint);
      canvas.drawLine(Offset(left + squareSize * i, top + squareSize * 5), Offset(left + squareSize * i, top + squareSize * 9), paint);
    }

    canvas.drawLine(Offset(left + squareSize * 3, top), Offset(left + squareSize * 5, top + squareSize * 2), paint);
    canvas.drawLine(Offset(left + squareSize * 5, top), Offset(left + squareSize * 3, top + squareSize * 2), paint);

    canvas.drawLine(Offset(left + squareSize * 3, top + squareSize * 9), Offset(left + squareSize * 5, top + squareSize * 7), paint);
    canvas.drawLine(Offset(left + squareSize * 5, top + squareSize * 9), Offset(left + squareSize * 3, top + squareSize * 7), paint);

    _drawStar(canvas, paint, left, top + squareSize * 3, leftHalf: false);
    _drawStar(canvas, paint, left + squareSize, top + squareSize * 2);
    _drawStar(canvas, paint, left + squareSize * 2, top + squareSize * 3);
    _drawStar(canvas, paint, left + squareSize * 4, top + squareSize * 3);
    _drawStar(canvas, paint, left + squareSize * 6, top + squareSize * 3);
    _drawStar(canvas, paint, left + squareSize * 7, top + squareSize * 2);
    _drawStar(canvas, paint, left + squareSize * 8, top + squareSize * 3, rightHalf: false);

    _drawStar(canvas, paint, left, top + squareSize * 6, leftHalf: false);
    _drawStar(canvas, paint, left + squareSize, top + squareSize * 7);
    _drawStar(canvas, paint, left + squareSize * 2, top + squareSize * 6);
    _drawStar(canvas, paint, left + squareSize * 4, top + squareSize * 6);
    _drawStar(canvas, paint, left + squareSize * 6, top + squareSize * 6);
    _drawStar(canvas, paint, left + squareSize * 7, top + squareSize * 7);
    _drawStar(canvas, paint, left + squareSize * 8, top + squareSize * 6, rightHalf: false);

  }

  static _drawStar(Canvas canvas, Paint paint, double x, double y, {leftHalf=true, rightHalf=true}) {
    final double offset = 2.5, length = 8;

    if (leftHalf) {
      canvas.drawLine(Offset(x - offset, y - offset), Offset(x - offset, y - offset - length), paint);
      canvas.drawLine(Offset(x - offset, y - offset), Offset(x - offset - length, y - offset), paint);
      canvas.drawLine(Offset(x - offset, y + offset), Offset(x - offset, y + offset + length), paint);
      canvas.drawLine(Offset(x - offset, y + offset), Offset(x - offset - length, y + offset), paint);
    }

    if (rightHalf) {
      canvas.drawLine(Offset(x + offset, y - offset), Offset(x + offset, y - offset - length), paint);
      canvas.drawLine(Offset(x + offset, y - offset), Offset(x + offset + length, y - offset), paint);
      canvas.drawLine(Offset(x + offset, y + offset), Offset(x + offset, y + offset + length), paint);
      canvas.drawLine(Offset(x + offset, y + offset), Offset(x + offset + length, y + offset), paint);
    }
  }
}