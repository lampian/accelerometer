// @dart=2.9
import 'package:accelerometer/widgets/value_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const POS_EDGE = 'Positive edge trigger';
const NEG_EDGE = 'Negative edge trigger';

class LevelTrigController extends GetxController {
  var startTrigLevel = 0.0.obs;
  var endTrigLevel = 0.0.obs;
  var startTrigIsPosEdge = true.obs;
  var endTrigIsPosEdge = true.obs;
  var startEdgeText = POS_EDGE.obs;
  var endEdgeText = POS_EDGE.obs;

  void startValueSliderCallBack(
    int handlerIndex,
    dynamic lowerValue,
    dynamic upperValue,
  ) {
    print('slider- lower: $lowerValue upper: $upperValue');
    startTrigLevel.value = lowerValue as double;
    //zoomMax = upperValue;
    //update();
  }

  void endValueSliderCallBack(
    int handlerIndex,
    dynamic lowerValue,
    dynamic upperValue,
  ) {
    print('slider- lower: $lowerValue upper: $upperValue');
    endTrigLevel.value = lowerValue as double;
    //zoomMax = upperValue;
    //update();
  }

  void startEdgeTextCallback() {
    if (startTrigIsPosEdge.value) {
      startEdgeText.value = NEG_EDGE;
      startTrigIsPosEdge.value = false;
    } else {
      startEdgeText.value = POS_EDGE;
      startTrigIsPosEdge.value = true;
    }
  }

  void endEdgeTextCallback() {
    if (endTrigIsPosEdge.value) {
      endEdgeText.value = NEG_EDGE;
      endTrigIsPosEdge.value = false;
    } else {
      endEdgeText.value = POS_EDGE;
      endTrigIsPosEdge.value = true;
    }
  }
}

class LevelTrigSetup extends GetWidget<LevelTrigController> {
  LevelTrigSetup(Map<dynamic, dynamic> map) {
    controller.startTrigLevel.value = map['startLevel'] as double;
    controller.startTrigIsPosEdge.value = !(map['startPosEdge'] as bool);
    controller.startEdgeTextCallback();
    controller.endTrigLevel.value = map['stopLevel'] as double;
    controller.endTrigIsPosEdge.value = !(map['stopPosEdge'] as bool);
    controller.endEdgeTextCallback();
  }

  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('set level'),
            actions: [],
          ),
          body: handleOrientation(),
        );
      },
    );
  }

  Widget handleOrientation() {
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
          flex: 9,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: Get.context.height,
                  color: Colors.blue[400],
                  child: startGroup(),
                ),
              ),
              Expanded(
                child: Container(
                  height: Get.context.height,
                  color: Colors.cyan[400],
                  child: endGroup(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ElevatedButton.icon(
            label: Text('Return'),
            icon: Icon(Icons.arrow_back_sharp),
            onPressed: () => Get.back(result: levelTrigData()),
            style: ElevatedButton.styleFrom(
              primary: Colors.blueGrey[600],
              elevation: 15.0,
              shadowColor: Colors.grey[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                    color: Get.theme.accentColor), //Colors.grey[600]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Map<dynamic, dynamic> levelTrigData() {
    return {
      'startLevel': controller.startTrigLevel.value,
      'startPosEdge': controller.startTrigIsPosEdge.value,
      'stopLevel': controller.endTrigLevel.value,
      'stopPosEdge': controller.endTrigIsPosEdge.value,
    };
  }

  Widget startGroup() {
    return Column(
      children: [
        Expanded(flex: 1, child: startTitleGroup()),
        Expanded(flex: 2, child: startEdgeGroup()),
        Expanded(flex: 1, child: startValueGroup()),
        Expanded(flex: 10, child: startSliderGroup()),
      ],
    );
  }

  Widget endGroup() {
    return Column(
      children: [
        Expanded(flex: 1, child: endTitleGroup()),
        Expanded(flex: 2, child: endEdgeGroup()),
        Expanded(flex: 1, child: endValueGroup()),
        Expanded(flex: 10, child: endSliderGroup()),
      ],
    );
  }

  Widget startTitleGroup() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
      color: Colors.green[200],
      child: Text(
        'Start level trigger',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget startEdgeGroup() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
      color: Colors.green[300],
      child: ElevatedButton(
        onPressed: () => controller.startEdgeTextCallback(),
        child: Obx(() => Text(controller.startEdgeText.value)),
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey[600],
          elevation: 15.0,
          shadowColor: Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Get.theme.accentColor), //Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget startValueGroup() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
      color: Colors.green[300],
      child: Obx(
        () => Text(
          controller.startTrigLevel.value.toStringAsPrecision(2),
        ),
      ),
    );
  }

  Widget startSliderGroup() {
    //Get.lazyPut(() => VSController(), tag: 'start');
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
      color: Colors.green[400],
      child: ValueSlider(
        cntlTag: 'start',
        vertical: true,
        min: 0.0, //this cant be neagtive since rms values are used in check
        max: 20.0,
        value: controller.startTrigLevel.value,
        callBack: controller.startValueSliderCallBack,
      ),
    );
  }

  Widget endTitleGroup() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
      color: Colors.green[200],
      child: Text(
        'End level trigger',
        style: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget endEdgeGroup() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
      color: Colors.green[300],
      child: ElevatedButton(
        onPressed: () => controller.endEdgeTextCallback(),
        child: Obx(() => Text(controller.endEdgeText.value)),
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey[600],
          elevation: 15.0,
          shadowColor: Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Get.theme.accentColor), //Colors.grey[600]),
          ),
        ),
      ),
    );
  }

  Widget endValueGroup() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
      color: Colors.green[300],
      child: Obx(
        () => Text(
          controller.endTrigLevel.value.toStringAsPrecision(2),
        ),
      ),
    );
  }

  Widget endSliderGroup() {
    //Get.lazyPut(() => VSController(), tag: 'end');
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.fromLTRB(6, 6, 6, 6),
      color: Colors.green[400],
      child: ValueSlider(
        cntlTag: 'end',
        vertical: true,
        min: 0.0, //cant be negative since rms values are used in check
        max: 20.0,
        value: controller.endTrigLevel.value,
        callBack: controller.endValueSliderCallBack,
      ),
    );
  }
}
