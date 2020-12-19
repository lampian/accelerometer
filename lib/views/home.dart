import 'package:accelerometer/controllers/home_controller.dart';
import 'package:accelerometer/utils/sensor_chart.dart';
import 'package:accelerometer/widgets/app_slider.dart';
import 'package:accelerometer/views/home_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Home extends GetWidget<HomeController> {
  Widget build(BuildContext context) {
    controller.initController();
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('title'),
            actions: [],
          ),
          drawer: HomeDrawer(),
          body: handleOrientation(),
        );
      },
    );
  }

  Widget handleOrientation() {
    if (Get.context.isLargeTablet) {
      return getPortrait();
    } else if (Get.context.isTablet) {
      return getPortrait();
    } else {
      if (Get.context.isLandscape) {
        return getLandscape();
      } else {
        return getPortrait();
      }
    }
  }

  Widget getLandscape() {
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: Container(
            color: Colors.orange[200],
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blue[200],
                    child: xGroup(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.green[200],
                    child: yGroup(),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.amber[200],
                    child: zGroup(),
                  ),
                ),
              ],
            ),
          ),
        ),

        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: Container(
              color: Colors.indigo[200],
              child: AppSlider(
                vertical: true,
                callBack: controller.sliderCallBack,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.lime,
            child: landscapeControlGroup(),
          ),
        ), //,
      ],
    );
  }

  Widget getPortrait() {
    return Column(
      children: [
        //SizedBox(height: 3),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.blue[200],
            child: xGroup(),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.green[200],
            child: yGroup(),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.amber[200],
            child: zGroup(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Container(
              color: Colors.transparent,
              child: AppSlider(
                vertical: false,
                callBack: controller.sliderCallBack,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.transparent,
            child: portraitControlGroup(),
          ),
        ), //,
      ],
    );
  }

  Widget xGroup() {
    return GetBuilder<HomeController>(builder: (value) {
      print('appChart(0) returned');
      return SensorChart(
        data: controller.getSeriesList('x'),
        x1: controller.dmnViewPortX1,
        x2: controller.dmnViewPortX2,
        title: 'X',
      );
    });
  }

  Widget yGroup() {
    return GetBuilder<HomeController>(builder: (value) {
      print('appChart(0) returned');
      return SensorChart(
          data: controller.getSeriesList('y'),
          x1: controller.dmnViewPortX1,
          x2: controller.dmnViewPortX2,
          title: 'Y');
    });
  }

  Widget zGroup() {
    return GetBuilder<HomeController>(builder: (value) {
      print('appChart(0) returned');
      return SensorChart(
          data: controller.getSeriesList('z'),
          x1: controller.dmnViewPortX1,
          x2: controller.dmnViewPortX2,
          title: 'Z');
    });
  }

  Widget portraitControlGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cmndButton(),
        trigStartButton(),
        trigStopButton(),
        captureButton(),
      ],
    );
  }

  Widget landscapeControlGroup() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cmndButton(),
        trigStartButton(),
        trigStopButton(),
        captureButton(),
      ],
    );
  }

  Widget cmndButton() {
    return GetX<HomeController>(
      //id: 'cmndButton',
      builder: (_) => ElevatedButton(
        child: Text(controller.cmndText),
        onPressed: () => controller.handleCmndPressed(),
        onLongPress: () async {
          await controller.handleLongPress(
            controller.cmndText,
            startStopText: 'run',
          );
        },
        style: ElevatedButton.styleFrom(
          primary: controller.waiting
              ? Colors.yellow[800]
              : Colors.blueGrey[600], //add waiting color
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

  Widget trigStartButton() {
    return ElevatedButton.icon(
      label: Obx(() => Text(controller.trigStartText())),
      icon: Icon(Icons.play_arrow),
      onPressed: () => controller.handleTrigStartPressed(),
      onLongPress: () async {
        await controller.handleLongPress(
          controller.trigStartText.value,
          startStopText: 'start',
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey[600],
        elevation: 15.0,
        shadowColor: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget trigStopButton() {
    return ElevatedButton.icon(
      label: Obx(() => Text(controller.trigStopText())),
      icon: Icon(Icons.stop),
      onPressed: () => controller.handleTrigStopPressed(),
      onLongPress: () async {
        await controller.handleLongPress(
          controller.trigStopText.value,
          startStopText: 'stop',
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey[600],
        elevation: 15.0,
        shadowColor: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget captureButton() {
    return ElevatedButton(
      child: Obx(() => Text(controller.modeText())),
      onPressed: () => controller.handleModePressed(),
      style: ElevatedButton.styleFrom(
        primary: Colors.blueGrey[600],
        elevation: 15.0,
        shadowColor: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
