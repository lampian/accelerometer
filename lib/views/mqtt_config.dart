import 'package:accelerometer/controllers/mqtt_config_controller.dart';
import 'package:accelerometer/models/mqtt_model.dart';
import 'package:accelerometer/services/mqtt_manager.dart';
import 'package:accelerometer/views/mqtt_model_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MqttConfig extends GetWidget<MqttConfigController> {
  @override
  Widget build(BuildContext context) {
    controller.mqttManager = Get.find<MqttManager>();
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Obx(() => Text(controller.title)),
            actions: [
              IconButton(
                onPressed: () => controller.handleMode(),
                icon: Obx(() => Icon(getIcon())),
              ),
            ],
          ),
          body: handleOrientation(context),
          floatingActionButton: Obx(() => fab()),
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
    return Column(
      children: [
        //SizedBox(height: 3),
        instructionField(),
        Expanded(
          flex: 1,
          child: listGroup(),
        ),
      ],
    );
  }

  Widget getLandscape() {
    return Column(
      children: [
        //SizedBox(height: 3),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue[200],
            child: listGroup(),
          ),
        ),
      ],
    );
  }

  Widget getTitle() {
    return Obx(() => Text(controller.title));
  }

  IconData getIcon() {
    var icon;
    switch (controller.mode) {
      case Mode.create:
        icon = Icons.add;
        break;
      case Mode.read:
        icon = Icons.view_agenda_sharp;
        break;
      case Mode.update:
        icon = Icons.edit_sharp;
        break;
      case Mode.delete:
        icon = Icons.delete_sharp;
        break;
      case Mode.copy:
        icon = Icons.copy_sharp;
        break;
      case Mode.configure:
        icon = Icons.developer_board;
        break;
      default:
        icon = Icons.view_agenda_sharp;
    }
    return icon;
  }

  Widget fab() {
    return Visibility(
      visible: controller.mode == Mode.create ? true : false,
      child: FloatingActionButton(
        onPressed: () {}, //create new model
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[600],
      ),
    );
  }

  Widget listGroup() {
    if (controller.mqttList == null) {
      return Text('loading..');
    } else if (controller.mqttList.isEmpty) {
      return Text('Nothing to show');
    } else {
      return ListView.builder(
        itemCount: controller.mqttList.length,
        itemBuilder: (_, index) => listTile(controller.mqttList[index]),
      );
    }
  }

  Widget listTile(MqttModel mqttModel) {
    return Column(
      children: [
        ListTile(
          enabled: controller.mode == Mode.create ? false : true,
          leading: Text(mqttModel.isPub ? 'Pub' : 'Sub'),
          title: Text(mqttModel.topic),
          subtitle: Text(mqttModel.identifier),
          //trailing: Text(mqttModel.qos.toString()),
          tileColor: Colors.grey[700],
          onTap: () => handleItemOnTap(mqttModel),
        ),
        Divider(height: 3),
      ],
    );
  }

  Widget instructionField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Select topic and project for capture \n'
        'by clicking one of the items',
        style: TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }

  void handleItemOnTap(MqttModel aMqttModel) {
    switch (controller.mode) {
      case Mode.create:
        break;
      case Mode.read:
        Get.to(MqttModelDetail(aMqttModel, true));
        break;
      case Mode.update:
        Get.to(MqttModelDetail(aMqttModel, false));
        break;
      case Mode.delete:
        break;
      case Mode.copy:
        break;
      case Mode.configure:
        var box = GetStorage();
        box.write('mqttdata', aMqttModel);
        controller.mqttManager.disconnect();
        controller.mqttManager.initializeMQTTClient();
        controller.mqttManager.connect();
        break;
      default:
    }
  }
}
