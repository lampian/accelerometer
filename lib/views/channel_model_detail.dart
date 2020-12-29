// @dart=2.9

import 'package:accelerometer/controllers/channel_model_detail_controller.dart';
import 'package:accelerometer/models/channel_model.dart';
import 'package:accelerometer/widgets/button_general.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChannelModelDetail extends GetWidget<ChannelModelDetailController> {
  ChannelModelDetail({bool readOnly, ChannelModel channelModel}) {
    controller.Initialise(
      readOnly,
      channelModel,
    );
    controller.setUser();
  }

  @override
  Widget build(BuildContext context) {
    //controller.mqttManager = Get.find<MqttManager>();
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
                'Channel information'), //Obx(() => Text(controller.title)),
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
          Expanded(flex: 1, child: modelGroup(1)),
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
            lbl: '*device ID',
            enable: false,
          ),
          SizedBox(height: 8),
          textBox(
            ctl: controller.channelIdTEC,
            lbl: 'Channel ID',
            enable: enabled,
          ),
          SizedBox(height: 8),
          textBox(
              ctl: controller.descriptionTEC,
              lbl: 'Description',
              enable: enabled),
          SizedBox(height: 8),
          textBox(
            ctl: controller.topicTEC,
            lbl: '*topic',
            enable: enabled,
          ),
          SizedBox(height: 8),
          //data or state
          textBox(
              ctl: controller.pubTEC,
              lbl: 'Publish identifier',
              enable: enabled),
          SizedBox(height: 8),
          //config or command
          textBox(
              ctl: controller.subTEC,
              lbl: 'Subscription identifier',
              enable: enabled),
          SizedBox(height: 8),
          textBox(
              ctl: controller.durationTEC,
              lbl: 'Signal active duration in milliseconds',
              enable: enabled),
          SizedBox(height: 8),
          //default is 2000
          textBox(
              ctl: controller.sampleRateTEC,
              lbl: 'Sampling rate used in milliseconds',
              enable: enabled),
          SizedBox(height: 8),
          //default auto
          textBox(
              ctl: controller.trigStartTEC,
              lbl: 'Trigger used to start telemetry',
              enable: enabled),
          SizedBox(height: 8),
          //default auto
          textBox(
              ctl: controller.trigStopTEC,
              lbl: 'Trigger used to stop telemetry',
              enable: enabled),
          SizedBox(height: 8),
          //default auto, start immediately,stop after duration'
          textBox(
              ctl: controller.trigSourceTEC,
              lbl: 'Source used for triggers',
              enable: enabled),
          SizedBox(height: 8),
          //Hint: 0, 1, 2'
          textBox(
              ctl: controller.qosTEC,
              lbl: 'MQTT QoS value for this channel',
              enable: enabled),
          SizedBox(height: 8),
          //Hint: DIGITAL_OUTPUT DIGITAL_INPUT ANALOG_INPUT..
          textBox(
              ctl: controller.ioTypeTEC,
              lbl: 'Type of input/output',
              enable: enabled),
          SizedBox(height: 8),
          //Hint: 0, 1
          textBox(
              ctl: controller.ioInitTEC,
              lbl: 'Starting value for outputs',
              enable: enabled),
        ],
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
        saveButton(),
      ],
    );
  }

  Widget cancelButton() {
    return GetBuilder<ChannelModelDetailController>(
      builder: (_) => ButtonGeneral(
        label: Text('Cancel'),
        icon: Icon(Icons.cancel),
        onPressedCallback: () => Get.back(),
        onLongPressedCallback: () => Get.back(),
      ),
    );
  }

  Widget saveButton() {
    return GetBuilder<ChannelModelDetailController>(
      builder: (_) => ButtonGeneral(
        enable: _.readOnly ? false : true,
        icon: Icon(Icons.save_rounded),
        label: Text('Save and return'),
        onLongPressedCallback: () => {},
        onPressedCallback: () async {
          if (await controller.saveChannel()) {
            Get.back();
          } else {
            print('app: channelModelDetail - save to firestore failed');
            Get.snackbar(
              'Error',
              'Save operation failed,'
                  ' check data entered and connection',
              snackPosition: SnackPosition.BOTTOM,
              snackStyle: SnackStyle.GROUNDED,
            );
          }
        },
      ),
    );
  }
}
