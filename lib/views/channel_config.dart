// @dart=2.9
import 'package:accelerometer/controllers/channel_config_controller.dart';
import 'package:accelerometer/models/channel_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChannelConfig extends GetWidget<ChannelConfigController> {
  ChannelConfig({this.uId, this.deviceId});
  final String uId;
  final String deviceId;
  @override
  Widget build(BuildContext context) {
    controller.Initialise(uId, deviceId);
    //controller.mqttManager = Get.find<MqttManager>();
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
      case ChanMode.create:
        icon = Icons.add;
        break;
      case ChanMode.read:
        icon = Icons.view_agenda_sharp;
        break;
      case ChanMode.update:
        icon = Icons.edit_sharp;
        break;
      case ChanMode.delete:
        icon = Icons.delete_sharp;
        break;
      case ChanMode.copy:
        icon = Icons.copy_sharp;
        break;
      case ChanMode.test:
        icon = Icons.science_sharp;
        break;
      default:
        icon = Icons.view_agenda_sharp;
    }
    return icon;
  }

  Widget fab() {
    return Visibility(
      visible: controller.mode == ChanMode.create ? true : false,
      child: FloatingActionButton(
        onPressed: () => handleItemOnTap(ChannelModel.emptyModel()),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.grey[600],
      ),
    );
  }

  Widget listGroup() {
    return GetX(
      builder: (cntl) {
        if (controller.channelList.isNull ?? true) {
          return Text('Loading..');
        } else if (controller.channelList.isEmpty) {
          //this causes a rebuild error => controller.mode = ChanMode.create;
          return Text('Nothing to show');
        } else {
          return ListView.builder(
            itemCount: controller.channelList.length,
            itemBuilder: (__, index) => listTile(controller.channelList[index]),
          );
        }
      },
    );
  }

  Widget listTile(ChannelModel channelModel) {
    return Column(
      children: [
        ListTile(
          enabled: controller.mode == ChanMode.create ? false : true,
          //leading: Text(mqttModel.isPub ? 'Pub' : 'Sub'),
          title: Text(channelModel.topic),
          subtitle: Text(channelModel.deviceID),
          //trailing: Text(mqttModel.qos.toString()),
          tileColor: Colors.grey[700],
          onTap: () => handleItemOnTap(channelModel),
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

  Future<void> handleItemOnTap(ChannelModel aChannelModel) async {
    switch (controller.mode) {
      case ChanMode.create:
        var emptyModel = ChannelModel.emptyModel();
        emptyModel.channelID = 'new channel id required';
        emptyModel.deviceID = controller.deviceId;
        //controller.editDetail(emptyModel, false);
        controller.editDetail(emptyModel, false);
        break;
      case ChanMode.read:
        controller.editDetail(aChannelModel, true);
        break;
      case ChanMode.update:
        controller.editDetail(aChannelModel, false);
        break;
      case ChanMode.delete:
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
          result = await controller.removeItem(aChannelModel);
          Get.snackbar(
            result ? 'Confirmation' : 'Error',
            result ? 'Operation suceeded' : 'Operation failed',
            snackPosition: SnackPosition.BOTTOM,
            snackStyle: SnackStyle.GROUNDED,
          );
        }
        break;
      case ChanMode.copy:
        aChannelModel.channelID = 'new channel identifier';
        controller.editDetail(aChannelModel, false);
        break;
      case ChanMode.test:
        break;
      default:
    }
  }
}
