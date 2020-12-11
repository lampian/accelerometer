import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/controllers/home_controller.dart';
import 'package:accelerometer/controllers/mqtt_config_controller.dart';
import 'package:accelerometer/controllers/mqtt_controller.dart';
import 'package:accelerometer/views/home.dart';
import 'package:accelerometer/views/level_trig_setup.dart';
import 'package:accelerometer/views/login.dart';
import 'package:accelerometer/views/timing_setup.dart';
import 'package:accelerometer/widgets/value_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return GetX(
      builder: (_) {
        print('ims: root');
        var aUser = controller.user;
        if (aUser == null) return Login();

        print('ims: root user- ${aUser.email}');
        if (controller.user?.uid != null) {
          Get.put<HomeController>(HomeController());
          Get.put<LevelTrigController>(LevelTrigController());
          Get.put<TimingSetupController>(TimingSetupController());
          Get.put<VSController>(VSController(), tag: 'start');
          Get.put<VSController>(VSController(), tag: 'end');
          Get.put<MqttController>(MqttController());
          Get.put<MqttConfigController>(MqttConfigController());
          return Home();
        } else {
          return Login();
        }
      },
    );
  }
}
