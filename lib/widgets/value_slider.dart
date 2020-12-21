// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';

class VSController extends GetxController {
  double min = 0.0;
  double max = 1.0;
  double value = 0.5;
}

class ValueSlider extends StatelessWidget {
  //GetView<VSController> {
  VSController get controller => Get.find<VSController>(tag: cntlTag ?? '');
  final bool vertical;
  final dynamic Function(int x, dynamic y, dynamic z) callBack;
  final String cntlTag;

  ValueSlider({
    @required this.cntlTag,
    @required this.vertical,
    @required min,
    @required max,
    @required value,
    @required this.callBack,
  }) {
    controller.min = min as double;
    controller.max = max as double;
    controller.value = value as double;
  }

  dynamic _dummyCallBack(int aVal, dynamic aX, dynamic aY) {}

  @override
  Widget build(BuildContext context) {
    //TODO rework
    dynamic Function(int x, dynamic y, dynamic z) aCallBack =
        callBack ?? _dummyCallBack;
    return FlutterSlider(
      rtl: true,
      centeredOrigin: false,
      rangeSlider: false,
      values: [controller.value],
      max: controller.max,
      min: controller.min,
      axis: vertical ?? false ? Axis.vertical : Axis.horizontal,
      onDragCompleted: aCallBack,
      trackBar: FlutterSliderTrackBar(
        activeTrackBarHeight: 6,
        // centralWidget: Container(
        //   decoration: BoxDecoration(
        //       color: Colors.blueAccent,
        //       borderRadius: BorderRadius.circular(50)),
        //   width: 9,
        //   height: 9,
        // ),
      ),
      tooltip: FlutterSliderTooltip(
        textStyle: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        boxStyle: FlutterSliderTooltipBox(
          decoration: BoxDecoration(
            color: Colors.redAccent.withOpacity(0.7),
          ),
        ),
        positionOffset: FlutterSliderTooltipPositionOffset(top: -10),
        alwaysShowTooltip: false,
      ),
    );
  }
}
