import 'package:chessroad/common/color-consts.dart';
import 'package:flutter/material.dart';

class WordsOnBoard extends StatelessWidget {
  static const DigitsFontSize = 18.0;

  @override
  Widget build(BuildContext context) {
    final blackColumns = '１２３４５６７８９', redColumns = '九八七六五四三二一';
    final bChildren = <Widget>[], rChildren = <Widget>[];

    final digitsStyle = TextStyle(fontSize: DigitsFontSize); 
    final riverTipsStyle = TextStyle(fontSize: 28.0);

    for (var i = 0; i < 9; i ++) {
      bChildren.add(Text(blackColumns[i], style: digitsStyle));
      rChildren.add(Text(redColumns[i], style: digitsStyle));

      if (i < 8) {
        bChildren.add(Expanded(child: SizedBox()));
        rChildren.add(Expanded(child: SizedBox()));
      }

    }

    final riverTips = Row(children: [
      Expanded(child: SizedBox()),
      Text('楚河', style: riverTipsStyle),
      Expanded(child: SizedBox(), flex: 2),
      Text('汉界', style: riverTipsStyle),
      Expanded(child: SizedBox())
    ]);

    return DefaultTextStyle(
      child: Column(
        children: [
          Row(children: bChildren),
          Expanded(child: SizedBox()),
          riverTips,
          Expanded(child: SizedBox()),
          Row(children: rChildren)
        ],
      ),
      style: TextStyle(color: ColorConsts.BoardTips)
    );
  }
}