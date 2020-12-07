import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class AppSlider extends StatelessWidget {
  bool vertical;
  Function callBack;

  AppSlider({
    @required this.vertical,
    @required this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      rangeSlider: true,
      values: [0, 100],
      max: 100,
      min: 0,
      axis: vertical ? Axis.vertical : Axis.horizontal,
      onDragCompleted: callBack,
    );
  }
}
