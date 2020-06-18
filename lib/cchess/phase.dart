import 'package:chessroad/cchess/steps-validate.dart';

import 'cc-base.dart';

class Phase {

  int halfMove = 0, fullMove = 0;

  String _side;

  BattleResult result = BattleResult.Pending;

  List<String> _pieces;

  get side => _side;
  turnSide() => _side = Side.oppo(_side);

  String pieceAt(int index) => _pieces[index];

  bool validateMove(int from, int to) {
    if (Side.of(_pieces[from]) != _side) return false;
    return StepValidate.validate(this, Move(from, to));
  }

  bool move(int from, int to) {
    if (!validateMove(from, to)) return false;
    if (_pieces[to] != Piece.Empty) {
      halfMove = 0;
    } else {
      halfMove ++;
    }

    if (fullMove == 0) {
      fullMove ++;
    } else if (side == Side.Black) {
      fullMove ++;
    }

    _pieces[to] = _pieces[from];
    _pieces[from] = Piece.Empty;

    _side = Side.oppo(_side);

    return true;
  }

  Phase.clone(other) {
    _pieces = List<String>();
    other._pieces.forEach((piece) => _pieces.add(piece));

    _side = other._side;
    halfMove = other.halfMove;
    fullMove = other.fullMove;
  }

  void moveTest(Move move, {turnSide = false}) {
    _pieces[move.to] = _pieces[move.from];
    _pieces[move.from] = Piece.Empty;

    if (turnSide) _side = Side.oppo(_side);
  }

  Phase.defaultPhase() {
    initDefaultPhase();
  }

  String toFen() {
    var fen = '';
    for (var row = 0; row < 10; row++) {
      var emptyCounter = 0;

      for (var column = 0; column < 9; column++) {
        final piece = pieceAt(row * 9 + column); 
        if (piece == Piece.Empty) {
          emptyCounter ++;
        } else {
          if (emptyCounter > 0) {
            fen += emptyCounter.toString();
            emptyCounter = 0;
          }

          fen += piece;
        }
      }

      if (emptyCounter > 0) fen += emptyCounter.toString();

      if (row < 9) fen += '/';
    }

    fen += ' $side';

    fen += ' - - ';

    fen += '$halfMove $fullMove';

    return fen;
  }

  void initDefaultPhase() {
    _side = Side.Red;
    _pieces = List<String>(90);

    _pieces[0 * 9 + 0] = Piece.BlackRook;
    _pieces[0 * 9 + 1] = Piece.BlackKnight;
    _pieces[0 * 9 + 2] = Piece.BlackBishop;
    _pieces[0 * 9 + 3] = Piece.BlackAdvisor;
    _pieces[0 * 9 + 4] = Piece.BlackKing;
    _pieces[0 * 9 + 5] = Piece.BlackAdvisor;
    _pieces[0 * 9 + 6] = Piece.BlackBishop;
    _pieces[0 * 9 + 7] = Piece.BlackKnight;
    _pieces[0 * 9 + 8] = Piece.BlackRook;

    _pieces[2 * 9 + 1] = Piece.BlackCanon;
    _pieces[2 * 9 + 7] = Piece.BlackCanon;

    _pieces[3 * 9 + 0] = Piece.BlackPawn;
    _pieces[3 * 9 + 2] = Piece.BlackPawn;
    _pieces[3 * 9 + 4] = Piece.BlackPawn;
    _pieces[3 * 9 + 6] = Piece.BlackPawn;
    _pieces[3 * 9 + 8] = Piece.BlackPawn;

    _pieces[9 * 9 + 0] = Piece.RedRook;
    _pieces[9 * 9 + 1] = Piece.RedKnight;
    _pieces[9 * 9 + 2] = Piece.RedBishop;
    _pieces[9 * 9 + 3] = Piece.RedAdvisor;
    _pieces[9 * 9 + 4] = Piece.RedKing;
    _pieces[9 * 9 + 5] = Piece.RedAdvisor;
    _pieces[9 * 9 + 6] = Piece.RedBishop;
    _pieces[9 * 9 + 7] = Piece.RedKnight;
    _pieces[9 * 9 + 8] = Piece.RedRook;

    _pieces[7 * 9 + 1] = Piece.RedCanon;
    _pieces[7 * 9 + 7] = Piece.RedCanon;

    _pieces[6 * 9 + 0] = Piece.RedPawn;
    _pieces[6 * 9 + 2] = Piece.RedPawn;
    _pieces[6 * 9 + 4] = Piece.RedPawn;
    _pieces[6 * 9 + 6] = Piece.RedPawn;
    _pieces[6 * 9 + 8] = Piece.RedPawn;


    for (var i = 0; i < 90; i ++) {
      _pieces[i] ??= Piece.Empty;
    }

  }
}
