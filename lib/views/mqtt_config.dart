import 'package:accelerometer/controllers/mqtt_config_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MqttConfig extends GetWidget<MqttConfigController> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Manage MQTT configuration'),
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
        return Container();
      }
    }
  }
}
