import 'package:accelerometer/models/mqtt_model.dart';
import 'package:accelerometer/services/database.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class MqttConfigController extends GetxController {
  var _mqttList = Rx<List<MqttModel>>();
  List<MqttModel> get mqttList => _mqttList.value;

  @override
  void onInit() {
    super.onInit();
    var uid = Get.find<AuthController>().user.uid;
    _mqttList.bindStream(Database().userMqttStream(uid));
  }
}
