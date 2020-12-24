import 'package:flutter/foundation.dart';

String durationToString({
  @required Duration duration,
  bool shortHand = false,
}) {
  String dStr = (duration.inDays).toString();
  String hStr = (duration.inHours % 24).toString();
  String mStr = (duration.inMinutes % 60).toString();
  String sStr = (duration.inSeconds % 60).toString();
  String msStr = (duration.inMilliseconds % 1000).toString();

  var strList = [dStr, hStr, mStr, sStr, msStr];
  var intList = [
    duration.inDays,
    duration.inHours % 24,
    duration.inMinutes % 60,
    duration.inSeconds % 60,
    duration.inMilliseconds % 1000,
  ];
  List<List<String>> unitList = [
    ['day', 'days', 'd'],
    ['hr', 'hrs', 'h'],
    ['min', 'min', 'm'],
    ['sec', 'sec', 's'],
    ['msec', 'msec', 'ms'],
  ];

  var first = intList.indexWhere(
    (element) => element > 0,
  );

  var last = intList.lastIndexWhere(
    (element) => element > 0,
  );

  if (first < 0 || last < 0) {
    return '-ms';
  }

  String aStr = '';
  for (int i = first; i <= last; i++) {
    if (shortHand) {
      aStr += strList[i] + unitList[i][2];
    } else if (intList[i] > 1) {
      aStr += strList[i] + unitList[i][1];
    } else if (intList[i] >= 0) {
      aStr += strList[i] + unitList[i][0];
    }

    //no trailing spaces
    if (i < last) {
      aStr += ' ';
    }
  }
  return aStr;
}
