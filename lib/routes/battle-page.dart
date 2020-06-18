import 'package:chessroad/board/board-widget.dart';
import 'package:chessroad/cchess/cc-base.dart';
import 'package:chessroad/common/color-consts.dart';
import 'package:chessroad/engine/cloud-engine.dart';
import 'package:chessroad/game/battle.dart';
import 'package:chessroad/main.dart';
import 'package:flutter/material.dart';

class BattlePage extends StatefulWidget {
  static double boardMargin = 10.0, screenPaddingH = 10.0;

  @override
  _BattlePageState createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {

  String _status = '';

  changeStatus(String status) => setState(() => _status = status);

  Widget buildFooter() {
    final size = MediaQuery.of(context).size;
    final manualText = '<暂无棋谱>';

    if (size.height / size.width > 16 / 9) {
      return buildManualPanel(manualText);
    } else {
      return buildExpandableManualPanel(manualText);
    }

  }

  Widget buildManualPanel(manualText) {
    final manualTextStyle = TextStyle(
      fontSize: 18,
      color: ColorConsts.DarkTextSecondary,
      height: 1.5
    );

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1),
        child: SingleChildScrollView(child: Text(manualText, style: manualTextStyle)),
      )
    );
  }

  Widget buildExpandableManualPanel(manualText) {
    final manualStyle = TextStyle(fontSize: 18, height: 1.5);

    return Expanded(child:IconButton(
      icon: Icon(Icons.expand_less, color: ColorConsts.DarkTextPrimary),
      onPressed: () => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('棋谱', style: TextStyle(color: ColorConsts.Primary)),
            content: SingleChildScrollView(child: Text(manualText, style: manualStyle)),
            actions: [
              FlatButton(
                child: Text('好的'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ]
          );
        }
      ),
    ));
  }

  void calcScreenPaddingH() {
    final windowSize = MediaQuery.of(context).size;
    double height = windowSize.height, width = windowSize.width;

    if (height/width < 16.0 /19.0) {
      width = height * 9/16;
      BattlePage.screenPaddingH = (windowSize.width - width) / 2 - BattlePage.boardMargin;
    }
  }

  void onBoardTap(BuildContext context, int pos) {
    final phase = Battle.shared.phase;

    if (phase.side != Side.Red) return;

    final tappedPiece = phase.pieceAt(pos);

    if (Battle.shared.focusIndex != Move.InvalidIndex && Side.of(phase.pieceAt(Battle.shared.focusIndex)) == Side.Red) {
      if (Battle.shared.focusIndex == pos) return;

      final focusPiece = phase.pieceAt(Battle.shared.focusIndex);

      if (Side.sameSide(focusPiece, tappedPiece)) {
        Battle.shared.select(pos);
      } else if (Battle.shared.move(Battle.shared.focusIndex, pos)) {
        final result = Battle.shared.scanBattleResult();

        switch(result) {
          case BattleResult.Pending:
            engineToGo();
            break;
          case BattleResult.Win:
            gotWin();
            break;
          case BattleResult.Lose:
            gotLose();
            break;
          case BattleResult.Draw:
            gotDraw();
            break;

        }
        // todo: scan game result
      }
    } else {
      if (tappedPiece != Piece.Empty) Battle.shared.select(pos);
    }
    
    setState(() {
    });
  }

  Widget createPageHeader() {
    final titleStyle = TextStyle(fontSize: 28, color: ColorConsts.DarkTextPrimary);
    final subTitleStyle = TextStyle(fontSize: 16, color: ColorConsts.DarkTextSecondary);

    return Container(
      margin: EdgeInsets.only(top: ChessRoadApp.StatusBarHeight),
      child: Column(
        children: [
          Row(children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back, color: ColorConsts.DarkTextPrimary),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Expanded(child: SizedBox()),
            Text('单机对战', style: titleStyle),
            Expanded(child: SizedBox()),
            IconButton(
              icon: Icon(Icons.settings, color: ColorConsts.DarkTextPrimary),
              onPressed: () {},
            ) 
          ],),
          Container(
            height: 4,
            width: 180,
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: ColorConsts.BoardBackground,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(_status, maxLines: 1, style: subTitleStyle)
          )

        ],
      )

    );
  }

  Widget createBoard() {
    final windowSize = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: BattlePage.screenPaddingH,
        vertical: BattlePage.boardMargin
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConsts.BoardBackground
      ),
      child: BoardWidget(
        width: windowSize.width - BattlePage.screenPaddingH,
        onBoardTap: onBoardTap,
      )
    );
  }

  Widget createOperatorBar() {
    final buttonStyle = TextStyle(color: ColorConsts.Primary, fontSize: 20);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: ColorConsts.BoardBackground
      ),
      margin: EdgeInsets.symmetric(horizontal: BattlePage.screenPaddingH),
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(children: <Widget>[
        Expanded(child: SizedBox()),
        FlatButton(child: Text('新对局', style: buttonStyle), onPressed: newGame,),
        Expanded(child: SizedBox()),
        FlatButton(child: Text('悔棋', style: buttonStyle), onPressed: () {}),
        Expanded(child: SizedBox()),
        FlatButton(child: Text('分析局面', style: buttonStyle), onPressed: () {}),
        Expanded(child: SizedBox()),
      ],)
    );
  }

  @override
  void initState() {
    super.initState();

    Battle.shared.init();
  }

  void engineToGo() async {
    changeStatus('对方思考中...');

    final response = await CloudEngine().search(Battle.shared.phase);

    if (response.type == 'move') {
      final step = response.value;
      Battle.shared.move(step.from, step.to);

      final result = Battle.shared.scanBattleResult();

      switch(result) {
        case BattleResult.Pending:
          changeStatus('请走棋...');
          break;
        case BattleResult.Win:
          gotWin();
          break;
        case BattleResult.Lose:
          gotLose();
          break;
        case BattleResult.Draw:
          gotDraw();
          break;
      }

    } else {
      changeStatus('Error: ${response.type}');
    }
  }

  void newGame() {
    confirm() {
      Navigator.of(context).pop();
      Battle.shared.newGame();
      setState(() {});
    }

    cancel() => Navigator.of(context).pop();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('放弃对局？', style: TextStyle(color: ColorConsts.Primary)),
          content: SingleChildScrollView(child: Text('你确定要放弃当前的对局吗？')),
          actions: <Widget> [
            FlatButton(child: Text('确定'), onPressed: confirm),
            FlatButton(child: Text('取消'), onPressed: cancel),
          ]
        );
      }
    );
  }

  void gotWin() {
    Battle.shared.phase.result = BattleResult.Win;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('赢了', style: TextStyle(color: ColorConsts.Primary)),
          content: Text('恭喜您取得了伟大的胜利！'),
          actions: <Widget>[
            FlatButton(child: Text('再来一盘'), onPressed: newGame),
            FlatButton(child: Text('关闭'), onPressed: () => Navigator.of(context).pop())
          ],
        );
      }
    );
  }

  void gotLose() {
    Battle.shared.phase.result = BattleResult.Lose;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('输了', style: TextStyle(color: ColorConsts.Primary)),
          content: Text('勇士，继续战斗，虽败犹荣！'),
          actions: <Widget>[
            FlatButton(child: Text('再来一盘'), onPressed: newGame),
            FlatButton(child: Text('关闭'), onPressed: () => Navigator.of(context).pop())
          ],
        );
      }
    );
  }

  void gotDraw() {
    Battle.shared.phase.result = BattleResult.Win;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('和棋', style: TextStyle(color: ColorConsts.Primary)),
          content: Text('您用自己的力量捍卫了和平！'),
          actions: <Widget>[
            FlatButton(child: Text('再来一盘'), onPressed: newGame),
            FlatButton(child: Text('关闭'), onPressed: () => Navigator.of(context).pop())
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final header = createPageHeader();
    final board = createBoard();
    final operatorBar = createOperatorBar();
    final footer = buildFooter();

    return Scaffold(
      backgroundColor: ColorConsts.DarkBackground,
      body: Column(children: <Widget>[header, board, operatorBar, footer])
    );
  }
}