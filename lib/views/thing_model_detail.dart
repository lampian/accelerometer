// @dart=2.9
import 'package:accelerometer/controllers/thing_model_detail_controller.dart';
import 'package:accelerometer/models/thing_model.dart';
import 'package:accelerometer/widgets/button_general.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';

class ThingModelDetail extends GetWidget<ThingModelDetailController> {
  ThingModelDetail(ThingModel thingModel, bool readOnly) {
    controller.updateModel(thingModel);
    controller.readOnly = readOnly;
  }
  @override
  Widget build(BuildContext context) {
    //controller.mqttManager = Get.find<MqttManager>();
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Mqtt Model data'), //Obx(() => Text(controller.title)),
            actions: [
              IconButton(
                icon: controller.readOnly ? Icon(Icons.list) : Icon(Icons.edit),
                onPressed: () {},
              ),
            ],
          ),
          body: handleOrientation(context),
          bottomNavigationBar: bottomGroup(),
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
        return getLandscape();
      } else {
        return getPortrait();
      }
    }
  }

  Widget getPortrait() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          //SizedBox(height: 3),
          Expanded(
            flex: 1,
            child: modelGroup(1),
          ),
        ],
      ),
    );
  }

  Widget getLandscape() {
    return Column(
      children: [
        //SizedBox(height: 3),
        Expanded(
          flex: 1,
          child: Container(
            //color: Colors.blue[200],
            child: modelGroup(2),
          ),
        ),
      ],
    );
  }

  Widget getTitle() {
    return Obx(() => Text(controller.title));
  }

  Widget modelGroup(int col) {
    var enabled = controller.readOnly ? false : true;
    return Container(
      color: Colors.transparent,
      child: ListView(
        children: [
          SizedBox(height: 8),
          textBox(
              ctl: controller.deviceIdTEC,
              lbl: '*device id',
              hnt: 'PubSub device id',
              enable: enabled),
          SizedBox(height: 8),
          textBox(
              ctl: controller.identifierTEC,
              lbl: '*identifier',
              hnt: 'PubSub identifier url',
              enable: enabled),
          SizedBox(height: 8),
          textBox(ctl: controller.hostTEC, lbl: '*host', enable: enabled),
          SizedBox(height: 8),
          textBox(ctl: controller.portTEC, lbl: 'port', enable: enabled),
          SizedBox(height: 8),
          textBox(ctl: controller.keepAliveTEC, lbl: 'period', enable: enabled),
        ],
      ),
    );
  }

  Widget switchBox(
      String active, String inactive, bool value, Function func, bool enable) {
    return Container(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ? active : inactive,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            FlutterSwitch(
              value: value,
              onToggle: (val) => func(val),
              activeColor: Get.theme.accentColor, //Colors.blueGrey[700],
              inactiveColor: Get.theme.accentColor, //Colors.blueGrey[700],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(
            color: Get.theme.accentColor), //Colors.grey[700], width: 1),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[800],
      ),
    );
  }

  Widget textBox({
    TextEditingController ctl,
    String lbl = '',
    String hnt = 'enter a string',
    bool enable = false,
  }) {
    return TextField(
      controller: ctl,
      keyboardType: TextInputType.emailAddress,
      enabled: enable,
      maxLines: null,
      style: TextStyle(
          //backgroundColor: Colors.transparent,
          color: Colors.grey[100],
          fontSize: 20.0),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        filled: true,
        labelText: lbl,
        hintText: hnt,
        //fillColor: Colors.grey[600],
        hintStyle: TextStyle(
          color: Colors.grey[100],
          //backgroundColor: Colors.transparent,
        ),
        labelStyle: TextStyle(
          color: Colors.grey[100],
          //backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Widget bottomGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        cancelButton(),
        if (!controller.readOnly) saveButton(),
      ],
    );
  }

  Widget cancelButton() {
    return GetBuilder<ThingModelDetailController>(
      builder: (_) => ElevatedButton(
        child: Text('Cancel'),
        onPressed: () {
          Get.back();
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey[600],
          elevation: 15.0,
          shadowColor: Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Get.theme.accentColor), //Colors.grey[700]),
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return ButtonGeneral(
        label: Text('Save and return'),
        icon: Icon(Icons.save_sharp),
        onPressedCallback: () async {
          if (await controller.saveMqtt()) {
            Get.back();
          } else {
            print('app: mqtModelDetail - save to firestore failed');
            Get.snackbar(
              'Error',
              'Save operation failed,'
                  ' check data entered and connection',
              snackPosition: SnackPosition.BOTTOM,
              snackStyle: SnackStyle.GROUNDED,
            );
          }
        },
        onLongPressedCallback: () {});
  }

  Widget saveButton1() {
    return GetBuilder<ThingModelDetailController>(
      builder: (_) => ElevatedButton(
        child: Text(controller.readOnly ? 'Ok' : 'Save and return'),
        onPressed: () async {
          if (await controller.saveMqtt()) {
            //Get.snackbar('Saved', 'Save operation succeeded');
            Get.back();
          } else {
            print('app: mqtModelDetail - save to firestore failed');
            Get.snackbar(
              'Error',
              'Save operation failed,'
                  ' check data entered and connection',
              snackPosition: SnackPosition.BOTTOM,
              snackStyle: SnackStyle.GROUNDED,
            );
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.blueGrey[600],
          elevation: 15.0,
          shadowColor: Colors.grey[700],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Get.theme.accentColor), //Colors.grey[700]),
          ),
        ),
      ),
    );
  }
}
