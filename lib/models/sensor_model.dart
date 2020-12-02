class SensorModel {
  SensorModel({
    this.channel,
    this.timeStamp,
    this.value,
    this.index,
  });
  DateTime timeStamp;
  int channel;
  double value;
  int index;
}
