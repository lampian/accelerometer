// @dart=2.9
import 'dart:convert';

import 'package:accelerometer/models/channel_model.dart';
import 'package:accelerometer/utils/storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum Modes { create, view, edit, delete, deleteAll }

class StorageManagerController extends GetxController {
  final _mode = Modes.view.obs;
  Modes get mode => _mode.value;
  set mode(Modes value) => _mode.value = value;

  final _items = Rx<List<Map<String, String>>>();
  List<Map<String, String>> get items => _items.value;
  set items(List<Map<String, String>> value) => _items.value = value;

  GetStorage bucket;

  void onInit() {
    super.onInit();
  }

  String getKey(int index) {
    return Storage.cleanMapValue(items[index].keys.toString());
  }

  String getValue(int index) {
    return Storage.cleanMapValue(items[index].values.toString());
  }

  void InitController() {
    bucket = GetStorage();
    items = buildItemList();
  }

  List<Map<String, String>> buildItemList() {
    var aChan = Storage.retrieveChannelModel();

    List<Map<String, String>> mapList = [];
    bucket.save();
    var keys = bucket.getKeys().toString();
    print('app: $keys');
    keys = Storage.cleanMapValue(keys);
    if (keys.isEmpty) {
      return mapList;
    }
    var strList = keys.split(',');
    strList.forEach((element) {
      print('app: storage values: $element-${bucket.read(element)}');

      var value = bucket.read(element).toString();
      Map<String, String> map = {element: value};
      mapList.add(map);
    });
    return mapList;
  }
}
