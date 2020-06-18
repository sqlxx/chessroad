
import 'package:chessroad/board/board-widget.dart';
import 'package:chessroad/board/painter-base.dart';
import 'package:chessroad/cchess/cc-base.dart';
import 'package:chessroad/cchess/phase.dart';
import 'package:chessroad/common/color-consts.dart';
import 'package:flutter/material.dart';

class PiecesPainter extends PainterBase {

  final Phase phase;
  final int focusIndex, blurIndex;
  double pieceSize;

  PiecesPainter({@required width, @required this.phase, this.focusIndex = Move.InvalidIndex, this.blurIndex = Move.InvalidIndex}) : super(width: width) {
    pieceSize = squareSize * 0.9;
  }
    
    @override
  void paint(Canvas canvas, Size size) {
    doPaint(canvas, thePaint, gridWidth: width, phase: phase, squareSize: squareSize, pieceSize: pieceSize, 
      offsetX: BoardWidget.Padding + squareSize / 2, offsetY: BoardWidget.Padding + BoardWidget.DigitsHeight + squareSize / 2, 
      focusIndex: focusIndex, blurIndex: blurIndex);
    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  static doPaint(
    Canvas canvas,
    Paint paint, {
      Phase phase,
      double gridWidth,
      double squareSize,
      double pieceSize,
      double offsetX,
      double offsetY,
      int focusIndex = Move.InvalidIndex,
      int blurIndex = Move.InvalidIndex 
    }
  ){

    final left = offsetX, top = offsetY;
    final shadowPath = Path();
    final piecesToDraw = <PiecePaintStub>[];

    for (var row = 0; row < 10; row++) {
      for (var column = 0; column < 9; column ++) {
        final piece = phase.pieceAt(row * 9 + column);
        if (piece == Piece.Empty) continue;
        
        var pos = Offset(left + squareSize * column, top + squareSize * row);
        piecesToDraw.add(PiecePaintStub(piece: piece, pos: pos));

        shadowPath.addOval(Rect.fromCenter(center: pos, width: pieceSize, height: pieceSize));
      }
    }

    canvas.drawShadow(shadowPath, Colors.black, 2, true);

    paint.style = PaintingStyle.fill;

    final textStyle = TextStyle(
      color: ColorConsts.PieceTextColor,
      fontSize: pieceSize * 0.9,
      fontFamily: 'Pinru',
      height: 1.0
    );

    piecesToDraw.forEach((pieceStub) {
      paint.color = Piece.isRed(pieceStub.piece) ? ColorConsts.RedPieceBoarderColor : ColorConsts.BlackPieceBorderColor;
      canvas.drawCircle(pieceStub.pos, pieceSize / 2 , paint);

      paint.color = Piece.isRed(pieceStub.piece) ? ColorConsts.RedPieceColor : ColorConsts.BlackPieceColor;
      canvas.drawCircle(pieceStub.pos, pieceSize * 0.8 / 2, paint);

      final textSpan = TextSpan(text: Piece.Names[pieceStub.piece], style: textStyle);
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();

      final textSize = textPainter.size;
      final metric = textPainter.computeLineMetrics()[0];
      final textOffset = pieceStub.pos - Offset(textSize.width / 2, metric.baseline - textSize.height / 4);

      textPainter.paint(canvas, textOffset);

    }); 

    if (focusIndex != Move.InvalidIndex) {
      int row = focusIndex ~/ 9, column = focusIndex % 9;
      paint.color = ColorConsts.FocusPosition;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 2;
      canvas.drawCircle(Offset(left + column * squareSize, top + row * squareSize), pieceSize / 2, paint);
        
    }

    if (blurIndex != Move.InvalidIndex) {
      int row = blurIndex ~/ 9, column = blurIndex % 9;
      paint.color = ColorConsts.BlurPosition;
      paint.style = PaintingStyle.fill;
      canvas.drawCircle(Offset(left + column * squareSize, top + row * squareSize), pieceSize / 2, paint);
    }

  }
}

class PiecePaintStub {
  final String piece;
  final Offset pos;
  PiecePaintStub({this.piece, this.pos});
}
