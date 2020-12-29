// @dart=2.9
import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/controllers/channel_config_controller.dart';
import 'package:accelerometer/controllers/channel_model_detail_controller.dart';
import 'package:accelerometer/controllers/home_controller.dart';
import 'package:accelerometer/controllers/storage_manager_controller.dart';
import 'package:accelerometer/controllers/thing_config_controller.dart';
import 'package:accelerometer/controllers/thing_model_detail_controller.dart';
import 'package:accelerometer/services/mqtt_manager.dart';
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
        print('app: root');
        print('app: user uid: ${controller.user?.uid}');
        // var aUser = controller.user;
        // if (aUser?.email == '') {
        //   return Login();
        // }

        //print('app: root user- ${aUser?.email}');
        if (controller.user?.uid != null) {
          Get.put<MqttManager>(MqttManager());
          Get.put<HomeController>(HomeController());
          Get.put<LevelTrigController>(LevelTrigController());
          Get.put<TimingSetupController>(TimingSetupController());
          Get.put<VSController>(VSController(), tag: 'start');
          Get.put<VSController>(VSController(), tag: 'end');
          Get.put<ChannelConfigController>(ChannelConfigController());
          Get.put<ChannelModelDetailController>(ChannelModelDetailController());
          Get.put<ThingModelDetailController>(ThingModelDetailController());
          Get.put<ThingConfigController>(ThingConfigController());
          Get.put<StorageManagerController>(StorageManagerController());
          return Home();
        } else {
          return Login();
        }
      },
    );
  }
}
