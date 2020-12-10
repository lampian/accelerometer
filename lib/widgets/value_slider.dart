import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';

class VSController extends GetxController {
  double min;
  double max;
  double value;
}

class VSControllerBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VSController(), tag: 'start');
    Get.lazyPut(() => VSController(), tag: 'end');
  }
}

class ValueSlider extends StatelessWidget {
  //GetView<VSController> {
  VSController get controller => Get.find<VSController>(tag: cntlTag);
  final bool vertical;
  final Function callBack;
  final String cntlTag;

  ValueSlider({
    @required this.cntlTag,
    @required this.vertical,
    @required min,
    @required max,
    @required value,
    @required this.callBack,
  }) {
    controller.min = min;
    controller.max = max;
    controller.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSlider(
      rtl: true,
      centeredOrigin: false,
      rangeSlider: false,
      values: [controller.value],
      max: controller.max,
      min: controller.min,
      axis: vertical ? Axis.vertical : Axis.horizontal,
      onDragCompleted: callBack,
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
