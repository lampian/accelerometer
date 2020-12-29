// @dart=2.9
import 'package:accelerometer/controllers/channel_config_controller.dart';
import 'package:accelerometer/models/channel_model.dart';
import 'package:accelerometer/utils/storage.dart';
import 'package:accelerometer/widgets/popup_option.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChannelConfig extends GetWidget<ChannelConfigController> {
  ChannelConfig({this.uId, this.deviceId});
  final String uId;
  final String deviceId;

  final popupItems = [
    PopupItem(icon: Icons.add, title: 'New'),
    PopupItem(icon: Icons.list, title: 'View'),
    PopupItem(icon: Icons.edit, title: 'Edit'),
    PopupItem(icon: Icons.delete, title: 'Delete'),
    PopupItem(icon: Icons.pest_control, title: 'Configure'),
    PopupItem(icon: Icons.science, title: 'Test'),
  ];

  @override
  Widget build(BuildContext context) {
    controller.Initialise(uId, deviceId);
    //controller.mqttManager = Get.find<MqttManager>();
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Obx(() => Text(controller.title + ' channels')),
            actions: [
              GetX<ChannelConfigController>(builder: (_) => buildPopupOption()),
            ],
          ),
          body: handleOrientation(context),
          //floatingActionButton: Obx(() => fab()),
        );
      },
    );
  }

  Widget buildPopupOption() {
    return PopupOption(
      icon: Icon(popupItems[controller.mode.index].icon),
      callBack: (_) {
        print('app: ${_.title}');
        controller.handleMode(_.title);
      },
      options: popupItems,
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

  Widget listGroup() {
    return GetX(
      builder: (cntl) {
        if (controller.channelList.isNull ?? true) {
          return Text('Loading..');
        } else if (controller.channelList.isEmpty) {
          //this causes a rebuild error => controller.mode = ChanMode.create;
          return Text('Nothing to show');
        } else {
          return GetX<ChannelConfigController>(
            builder: (_) => ListView.builder(
              itemCount: controller.channelList.length,
              itemBuilder: (__, index) =>
                  listTile(controller.channelList[index]),
            ),
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
          trailing: Text(channelModel.channelID),
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
        'Select a channel for viewing or editing',
        style: TextStyle(
          fontSize: 18,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Future<void> handleItemOnTap(ChannelModel aChannelModel) async {
    switch (controller.mode) {
      case ChanMode.create:
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
      case ChanMode.configure:
        Storage.storeChannelModel(aChannelModel);
        Get.snackbar('Confirmation:', 'Mqtt channel information stored locally',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Get.theme.backgroundColor, //Colors.grey[700],
            duration: Duration(seconds: 5));
        break;
      case ChanMode.test:
        break;
      default:
    }
  }
}
