import 'package:accelerometer/controllers/auth_controller.dart';
import 'package:accelerometer/controllers/home_controller.dart';
import 'package:accelerometer/utils/root.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Home extends GetWidget<HomeController> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
        actions: [],
      ),
      drawer: menu(),
      body: getBody(),
    );
  }

  menu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(3.0),
        children: [
          Container(
            height: 60.0,
            child: DrawerHeader(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Select action:',
                  textAlign: TextAlign.end,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.green[300],
              ),
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              margin: EdgeInsets.all(0.0),
            ),
          ),
          ListTile(
            title: Text('Toggle theme black'),
            onTap: () {
              if (Get.isDarkMode) {
                Get.changeTheme(ThemeData.light());
              } else {
                Get.changeTheme(ThemeData.dark());
              }
            },
          ),
          ListTile(
            title: Text('Sign out'),
            onTap: () {
              Get.find<AuthController>().signOut();
              Get.offAll(Root());
            },
          ),
        ],
      ),
    );
  }

  getBody() {}
}
