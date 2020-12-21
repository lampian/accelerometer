// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class AppSlider extends StatelessWidget {
  AppSlider({
    @required this.vertical,
    @required this.callBack,
  });
  final bool vertical;
  final dynamic Function(int x, dynamic y, dynamic z) callBack;

  dynamic _dummyCallBack(int aVal, dynamic aX, dynamic aY) {}

  @override
  Widget build(BuildContext context) {
    //Function aCallBack = callBack ?? () {};
    dynamic Function(int x, dynamic y, dynamic z) aFunc =
        callBack ?? _dummyCallBack;
    return FlutterSlider(
      rangeSlider: true,
      values: [0, 100],
      max: 100,
      min: 0,
      axis: vertical ?? false ? Axis.vertical : Axis.horizontal,
      //onDragCompleted: callBack == null ? () {} : aCallBack(),
      onDragCompleted: aFunc,
    );
  }
}
