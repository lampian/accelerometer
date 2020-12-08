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
}
