// @dart=2.9
import 'package:accelerometer/controllers/thing_config_controller.dart';
import 'package:accelerometer/models/thing_model.dart';
import 'package:accelerometer/services/mqtt_manager.dart';
import 'package:accelerometer/utils/storage.dart';
import 'package:accelerometer/views/channel_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:get/get.dart';

class ThingConfig extends GetWidget<ThingConfigController> {
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
    IconData icon;
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
        onPressed: () => handleItemOnTap(ThingModel.emptyModel()),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[600],
      ),
    );
  }

  Widget listGroup() {
    if (controller.thingList.isEmpty) {
      return Text('Nothing to show');
    } else {
      return GetX<ThingConfigController>(
        builder: (_) => ListView.builder(
          itemCount: _.thingList.length,
          itemBuilder: (__, index) => listTile(_.thingList[index]),
        ),
      );
    }
  }

  Widget listTile(ThingModel thingModel) {
    return Column(
      children: [
        ListTile(
          enabled: controller.mode == Mode.create ? false : true,
          //leading: Text(mqttModel.isPub ? 'Pub' : 'Sub'),
          title: Text(thingModel.id),
          subtitle: Text(thingModel.identifier),
          trailing: IconButton(
              icon: Icon(Icons.miscellaneous_services_sharp),
              onPressed: () => Get.to(
                    ChannelConfig(
                      deviceId: thingModel.id,
                      uId: controller.user.uid,
                    ),
                  )),
          tileColor: Colors.grey[700],
          onTap: () => handleItemOnTap(thingModel),
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

  Future<void> handleItemOnTap(ThingModel thingModel) async {
    final Guid aGUID = Guid.newGuid;
    final idText = aGUID.value;
    switch (controller.mode) {
      case Mode.create:
        var emptyModel = ThingModel.emptyModel();
        emptyModel.id = idText;
        controller.editDetail(emptyModel, false);
        break;
      case Mode.read:
        controller.editDetail(thingModel, true);
        break;
      case Mode.update:
        controller.editDetail(thingModel, false);
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
          result = await controller.removeItem(thingModel);
          Get.snackbar(
            result ? 'Confirmation' : 'Error',
            result ? 'Operation suceeded' : 'Operation failed',
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.GROUNDED,
          );
        }
        break;
      case Mode.copy:
        thingModel.id = idText;
        controller.editDetail(thingModel, false);
        break;
      case Mode.configure:
        Storage.storeMqttModel(thingModel);
        Get.snackbar('Confirmation:', 'Mqtt information stored locally',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.accentColor, //Colors.grey[700],
            duration: Duration(seconds: 5));
        break;
      case Mode.test:
        // controller.mqttManager.disconnect();
        // if (controller.mqttManager.initializeMQTTClient()) {
        //   controller.mqttManager.connect();
        //   var model = SensorModel(
        //     channel: 1,
        //     timeStamp: DateTime(2020, 12, 1, 12, 30, 20, 123),
        //     valueX: 2,
        //     valueY: -3,
        //     valueZ: 4,
        //     index: 0,
        //   );
        //   var aList = <SensorModel>[];
        //   aList.add(model);
        //   if (await controller.mqttManager.isConnectedAsync()) {
        //     controller.mqttManager
        //         .publish(SensorModelConvert.toJsonEncoded('1000', aList));
        //     controller.mqttManager.disconnect();
        //     Get.snackbar(
        //         'Confirmation:',
        //         'Test complete.'
        //             '\nMqtt initialised, message published and connection closed',
        //         snackPosition: SnackPosition.BOTTOM,
        //         backgroundColor: Get.theme.accentColor, //Colors.grey[700],
        //         duration: Duration(seconds: 8));
        //   }
        // } else {
        //   Get.snackbar(
        //       'Error:', 'Mqtt initialisation failed - configure device',
        //       snackPosition: SnackPosition.BOTTOM,
        //       backgroundColor: Get.theme.accentColor, //Colors.grey[700],
        //       duration: Duration(seconds: 5));
        // }
        break;
      default:
    }
  }
}
