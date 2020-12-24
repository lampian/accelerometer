// @dart=2.9
import 'package:accelerometer/controllers/home_controller.dart';
import 'package:accelerometer/utils/sensor_chart.dart';
import 'package:accelerometer/widgets/app_slider.dart';
import 'package:accelerometer/views/home_drawer.dart';
import 'package:accelerometer/widgets/button_general.dart';

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
          drawer: HomeDrawer(key: GlobalKey()),
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
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: Container(
              color: Colors.transparent,
              child: infoGroupLandscape(),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.transparent,
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
              child: infoGroupPortrait(),
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

  Widget infoGroupLandscape() {
    return GetX<HomeController>(
      builder: (_) => _.showInfo
          ? infoPortrait()
          : AppSlider(
              vertical: true,
              callBack: _.sliderCallBack,
            ),
    );
  }

  Widget infoGroupPortrait() {
    return GetX<HomeController>(
      builder: (_) => _.showInfo
          ? infoPortrait()
          : AppSlider(
              vertical: false,
              callBack: _.sliderCallBack,
            ),
    );
  }

  Widget infoPortrait() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.transparent,
        child: Center(
            child: Text(
          controller.info,
          style: TextStyle(color: Get.theme.indicatorColor, fontSize: 18),
        )),
      ),
    );
  }

  Widget xGroup() {
    return GetBuilder<HomeController>(builder: (value) {
      print('app: appChart(0) returned');
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
      print('app: appChart(0) returned');
      return SensorChart(
          data: controller.getSeriesList('y'),
          x1: controller.dmnViewPortX1,
          x2: controller.dmnViewPortX2,
          title: 'Y');
    });
  }

  Widget zGroup() {
    return GetBuilder<HomeController>(builder: (value) {
      print('app: appChart(0) returned');
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
    return ButtonGeneral(
      label: Obx(() => Text(controller.cmndText)),
      icon: Icon(Icons.arrow_forward_sharp),
      onPressedCallback: controller.handleCmndPressed,
      onLongPressedCallback: () async {
        await controller.handleLongPress(
          controller.cmndText,
          startStopText: 'run',
        );
      },
    );
  }

  Widget trigStartButton() {
    return ButtonGeneral(
      label: Obx(() => Text(controller.trigStartText)),
      icon: Icon(Icons.subdirectory_arrow_right_sharp),
      onPressedCallback: controller.handleTrigStartPressed,
      onLongPressedCallback: () async {
        await controller.handleLongPress(
          controller.trigStartText,
          startStopText: 'start',
        );
      },
    );
  }

  Widget trigStopButton() {
    return ButtonGeneral(
      label: Obx(() => Text(controller.trigStopText)),
      icon: Icon(Icons.keyboard_tab_sharp),
      onPressedCallback: controller.handleTrigStopPressed,
      onLongPressedCallback: () async {
        await controller.handleLongPress(
          controller.trigStopText,
          startStopText: 'stop',
        );
      },
    );
  }

  Widget captureButton() {
    return GetX<HomeController>(
      builder: (ctl) => ButtonGeneral(
        label: Text(ctl.modeText),
        icon: Icon(ctl.isCloud ? Icons.cloud_upload_sharp : Icons.save_alt),
        onPressedCallback: ctl.handleModePressed,
        onLongPressedCallback: () async {
          await ctl.handleLongPress(
            ctl.trigStopText,
            startStopText: 'mode',
          );
        },
      ),
    );
  }
}
