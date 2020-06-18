import 'package:chessroad/cchess/cc-base.dart';
import 'package:chessroad/cchess/cc-rules.dart';
import 'package:chessroad/cchess/phase.dart';

class Battle {
  static Battle _instance;

  static get shared {
    _instance ??= Battle();
    return _instance;
  }
  
  Phase _phase;
  int _focusIndex, _blurIndex;

  init() {
    _phase = Phase.defaultPhase();
    _focusIndex = _blurIndex = Move.InvalidIndex;
  }

  get phase => _phase;

  get blurIndex => _blurIndex;

  get focusIndex => _focusIndex;

  bool move(int from, int to) {
    if (!_phase.move(from, to)) return false;

    _blurIndex = from;
    _focusIndex = to;

    return true;
  }

  clear() {
    _blurIndex = _focusIndex = Move.InvalidIndex;
  }

  select(int pos) {
    _focusIndex = pos;
  }

  newGame() {
    Battle.shared._phase.initDefaultPhase();
    _focusIndex = _blurIndex = Move.InvalidIndex;
  }

  BattleResult scanBattleResult() {
    final forPerson = (phase.side == Side.Red);

    if (scanLongCatch()) {
      return forPerson ? BattleResult.Win : BattleResult.Lose;
    }

    if (ChessRules.beKilled(_phase)) {
      return forPerson ? BattleResult.Lose : BattleResult.Win;
    }

    return (_phase.halfMove > 120) ? BattleResult.Draw : BattleResult.Pending;

  }

  scanLongCatch() {
    return false;
  }
}
