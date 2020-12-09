import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/controllers/home_controller.dart';
import 'package:accelerometer/views/home.dart';
import 'package:accelerometer/views/level_trig_setup.dart';
import 'package:accelerometer/views/login.dart';
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
          return Home();
        } else {
          return Login();
        }
      },
    );
  }
}
