// @dart=2.9
import 'package:accelerometer/controllers/storage_manager_controller.dart';
import 'package:accelerometer/widgets/popup_option.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StorageManagement extends GetWidget<StorageManagerController> {
  final popupItems = [
    PopupItem(icon: Icons.add, title: 'New item'),
    PopupItem(icon: Icons.list, title: 'View'),
    PopupItem(icon: Icons.edit, title: 'Edit'),
    PopupItem(icon: Icons.delete, title: 'Delete item'),
    PopupItem(icon: Icons.delete, title: 'Delete all'),
  ];
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (_, orientaion) => Scaffold(
        appBar: AppBar(
          title: Text('Manage local storage'),
          actions: [
            GetX(
              builder: (_) => popUpOption(),
            ),
          ],
        ),
        body: handleOrientation(context),
      ),
    );
  }

  Widget popUpOption() {
    return PopupOption(
      icon: Icon(popupItems[controller.mode.index].icon),
      callBack: (_) async => await handleMode(_.title),
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
        //instructionField(),
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

  Widget listGroup() {
    controller.InitController();
    if (controller.items.isEmpty) {
      return Center(
          child: Text(
        'Nothing to show',
        style: TextStyle(fontSize: 18),
      ));
    } else {
      return ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (__, index) => Padding(
          padding: const EdgeInsets.all(6.0),
          child: GestureDetector(
            onTap: () => {print('app: selected $index')},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: Text(
                      '${controller.getKey(index)}',
                      style: TextStyle(fontSize: 18),
                    )),
                Flexible(
                    flex: 1,
                    child: Text(
                      ' : ',
                      style: TextStyle(fontSize: 18),
                    )),
                Flexible(
                    flex: 8,
                    child: Text(
                      '${controller.getValue(index)}',
                      style: TextStyle(fontSize: 18),
                    )),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> handleMode(String retstr) async {
    switch (retstr) {
      case 'New item':
        break;
      case 'View':
        break;
      case 'Edit':
        break;
      case 'Delete item':
        break;
      case 'Delete all':
        var result = await Get.defaultDialog<bool>(
          title: 'Delete all:',
          middleText: 'Are you sure?',
          onCancel: () {
            Get.back(result: false, canPop: true);
          },
          onConfirm: () {
            Get.back(result: true);
          },
        );
        if (result) {
          await controller.bucket.erase();
        }
        break;
      default:
        break;
    }
  }
}
