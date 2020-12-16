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
  DateTime timeStamp;
  int channel;
  double valueX;
  double valueY;
  double valueZ;
  int index;
  double rms() {
    return sqrt(valueX * valueX + valueY * valueY + valueZ * valueZ);
  }

  int mms2rms() {
    var x = rms() * 1000;
    return x.toInt();
  }

  Map<String, dynamic> toJsonMap(String device) => {
        "t": timeStamp.millisecondsSinceEpoch / 1000,
        "d": int.parse(device),
        "c": channel,
        "v": mms2rms(),
      };
}

class SensorModelConvert {
  static String toJsonBase64(String device, List<SensorModel> modelList) {
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
