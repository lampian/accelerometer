// @dart=2.9
import 'dart:convert';
import 'dart:math';

class SensorModel {
  SensorModel({
    this.channel,
    this.timeStamp,
    this.valueX,
    this.valueY,
    this.valueZ,
    this.index,
  });
  DateTime timeStamp = DateTime.now();
  int channel = 0;
  double valueX = 0;
  double valueY = 0;
  double valueZ = 0;
  int index = 0;

  double rms() {
    var x = valueX ?? 0;
    var y = valueY ?? 0;
    var z = valueZ ?? 0;
    return sqrt(x * x + y * y + z * z);
    //TODO null issues revisit
    //return sqrt(valueX * valueX + valueY * valueY + valueZ * valueZ);
  }

  int mms2rms() {
    var x = rms() * 1000;
    return x.toInt();
  }

  Map<String, dynamic> toJsonMap(String device) => {
        "t": (timeStamp?.millisecondsSinceEpoch ?? 0) / 1000,
        "d": int.parse(device),
        "c": channel,
        "v": mms2rms(),
      };
}

class SensorModelConvert {
  static String toJsonEncoded(String device, List<SensorModel> modelList) {
    var outStr = '';
    modelList.forEach((element) {
      outStr = outStr + jsonEncode(element.toJsonMap(device)) + ',';
    });
    outStr = outStr.substring(0, outStr.length - 1);
    return outStr = '{"values":[' + outStr + ']}';

    // var aByteList = outStr.codeUnits;
    // var aBase64 = Base64Encoder().convert(aByteList);
    // return aBase64;
  }
}
