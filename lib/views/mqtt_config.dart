import 'package:accelerometer/controllers/mqtt_config_controller.dart';
import 'package:accelerometer/models/mqtt_model.dart';
import 'package:accelerometer/models/sensor_model.dart';
import 'package:accelerometer/services/mqtt_manager.dart';
import 'package:accelerometer/utils/storage.dart';
import 'package:accelerometer/views/mqtt_model_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
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
      case Mode.test:
        icon = Icons.science_sharp;
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
        onPressed: () => handleItemOnTap(null), //create new model
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
      return GetX<MqttConfigController>(
        builder: (_) => ListView.builder(
          itemCount: _.mqttList.length,
          itemBuilder: (__, index) => listTile(_.mqttList[index]),
        ),
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

  Future<void> handleItemOnTap(MqttModel aMqttModel) async {
    final Guid aGUID = Guid.newGuid;
    final idText = aGUID.value;
    switch (controller.mode) {
      case Mode.create:
        controller.editDetail(controller.getEmptyModel(idText), false);
        break;
      case Mode.read:
        controller.editDetail(aMqttModel, true);
        break;
      case Mode.update:
        controller.editDetail(aMqttModel, false);
        break;
      case Mode.delete:
        var result = await Get.defaultDialog<bool>(
          title: 'Deleting item',
          middleText: 'Are you sure?',
          onCancel: () {
            Get.back(result: false, canPop: true);
          },
          onConfirm: () {
            Get.back(result: true);
          },
        );
        if (result == true) {
          result = await controller.removeItem(aMqttModel);
          Get.snackbar(
            result ? 'Confirmation' : 'Error',
            result ? 'Operation suceeded' : 'Operation failed',
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.GROUNDED,
          );
        }
        break;
      case Mode.copy:
        aMqttModel.id = idText;
        controller.editDetail(aMqttModel, false);
        break;
      case Mode.configure:
        Storage.storeMqttModel(aMqttModel);
        controller.mqttManager.disconnect();
        if (controller.mqttManager.initializeMQTTClient())
          controller.mqttManager.connect();
        break;
      case Mode.test:
        // Storage.storeMqttModel(aMqttModel);
        // controller.mqttManager.disconnect();
        // if (controller.mqttManager.initializeMQTTClient())
        //   controller.mqttManager.connect();
        var model = SensorModel(
          channel: 1,
          timeStamp: DateTime(2020, 12, 1, 12, 30, 20, 123),
          valueX: 2,
          valueY: -3,
          valueZ: 4,
        );
        var aList = <SensorModel>[];
        aList.add(model);
        controller.mqttManager
            .publish(SensorModelConvert.toJsonBase64('1000', aList));
        break;
      default:
    }
  }
}
