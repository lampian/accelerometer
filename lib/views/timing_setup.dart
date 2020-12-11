import 'package:accelerometer/widgets/value_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';

class TimingSetupController extends GetxController {
  var days = 0.obs;
  var hrs = 0.obs;
  var min = 0.obs;
  var sec = 0.obs;
  var msec = 0.obs;
}

class TimingSetup extends GetWidget<TimingSetupController> {
  TimingSetup({Duration duration}) {
    controller.days.value = duration.inDays;
    controller.hrs.value = duration.inHours % 24;
    controller.min.value = duration.inMinutes % 60;
    controller.sec.value = duration.inSeconds % 60;
    controller.msec.value = duration.inMilliseconds % 1000;
  }
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Timing setup'),
          ),
          body: handleOrientation(context),
        );
      },
    );
  }

  Widget handleOrientation(BuildContext context) {
    if (Get.context.isLargeTablet) {
      return Container();
    } else if (Get.context.isTablet) {
      return Container();
    } else {
      if (Get.context.isLandscape) {
        return Container();
      } else {
        return getPortrait();
      }
    }
  }

  Widget getPortrait() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(3, 60, 3, 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: sliderGroupDays()),
                Expanded(flex: 1, child: sliderGroupHours()),
                Expanded(flex: 1, child: sliderGroupMinutes()),
                Expanded(flex: 1, child: sliderGroupSeconds()),
                Expanded(flex: 1, child: sliderGroupMiliseconds()),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              height: Get.context.height,
              color: Colors.blue[400],
              child: acceptCntl()),
        ),
      ],
    );
  }

  Container sliderGroupDays() {
    return sliderGroup(
        tooltipText: 'Day: \n',
        min: 0,
        max: 31,
        val: controller.days.value.toDouble(),
        vertical: true,
        callBack: (int, min, max) => {controller.days.value = min.toInt()});
  }

  Container sliderGroupHours() {
    return sliderGroup(
        tooltipText: 'Hrs: \n',
        min: 0,
        max: 23,
        val: controller.hrs.value.toDouble(),
        vertical: true,
        callBack: (int, min, max) => {controller.hrs.value = min.toInt()});
  }

  Container sliderGroupMinutes() {
    return sliderGroup(
        tooltipText: 'Min: \n',
        min: 0,
        max: 59,
        val: controller.min.value.toDouble(),
        vertical: true,
        callBack: (int, min, max) => {controller.min.value = min.toInt()});
  }

  Container sliderGroupSeconds() {
    return sliderGroup(
        tooltipText: 'Sec: \n',
        min: 0,
        max: 59,
        val: controller.sec.value.toDouble(),
        vertical: true,
        callBack: (int, min, max) => {controller.sec.value = min.toInt()});
  }

  Container sliderGroupMiliseconds() {
    return sliderGroup(
        tooltipText: 'ms: \n',
        min: 0,
        max: 999,
        val: controller.msec.value.toDouble(),
        vertical: true,
        callBack: (int, min, max) => {controller.msec.value = min.toInt()});
  }

  Container sliderGroup({
    String tooltipText,
    double val,
    double min,
    double max,
    bool vertical,
    Function callBack,
  }) {
    return Container(
      height: Get.context.height,
      color: Colors.blue[100],
      child: FlutterSlider(
        rtl: true,
        centeredOrigin: false,
        rangeSlider: false,
        values: [val],
        max: max,
        min: min,
        axis: vertical ? Axis.vertical : Axis.horizontal,
        onDragCompleted: callBack,
        trackBar: FlutterSliderTrackBar(
          activeTrackBarHeight: 6,
        ),
        tooltip: FlutterSliderTooltip(
          format: (String value) => tooltipText + value,
          textStyle: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
          boxStyle: FlutterSliderTooltipBox(
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.7),
            ),
          ),
          positionOffset: FlutterSliderTooltipPositionOffset(top: -50),
          alwaysShowTooltip: true,
        ),
      ),
    );
  }

  Widget acceptCntl() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: ElevatedButton.icon(
        label: Text('Accept'),
        icon: Icon(Icons.arrow_back_sharp),
        onPressed: () => Get.back(result: getDuration()),
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey[600],
          elevation: 15.0,
          shadowColor: Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Duration getDuration() {
    var duration = Duration(
        milliseconds: controller.msec.value +
            (controller.sec.value * 1000) +
            (controller.min.value * 60 * 1000) +
            (controller.hrs.value * 60 * 60 * 1000) +
            (controller.days.value * 24 * 60 * 60 * 1000));
    print('timing seup getDuration duration: $duration');
    return duration;
  }
}
