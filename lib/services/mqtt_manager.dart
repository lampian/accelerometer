import 'dart:io';

import 'package:accelerometer/certificate/keys.dart';
import 'package:accelerometer/certificate/rsa_file_handler.dart';
import 'package:accelerometer/models/mqtt_model.dart';
import 'package:get/state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jose/jose.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

enum MqttConnectState { connected, disconnected, connecting }

class MqttManager extends GetxController {
  MqttManager({this.mqttModel, this.rsaFile});
  MqttModel mqttModel;
  MqttServerClient _client;
  String rsaFile;
  var appConnectionState = MqttConnectState.disconnected;
  final username = 'unused'; //unused but required dont delete
  String password;

  var _history = '';
  String get history => _history;
  set history(val) => _history = val;

  var _received = '';
  String get received => _received;
  set received(value) {
    _received = value;
    history = history + '\n' + received;
  }

  var _lastRxTopic = 'no topic available';
  String get lastRxTopic => _lastRxTopic;
  set lastRxTopic(val) => _lastRxTopic = val;

  var _lastRxMsg = 'no message available';
  String get lastRxMsg => this._lastRxMsg;
  set lastRxMsg(val) => this._lastRxMsg = val;

  @override
  Future<void> onInit() async {
    super.onInit();
    rsaFile = await getRsaFilePath(rsaPrivateKey);
    loadModelData();
  }

  bool loadModelData() {
    mqttModel = GetStorage().read('mqqtdata');
    if (mqttModel == null ||
        mqttModel.host == null ||
        mqttModel.host.isEmpty) //check if box has anything in it
    {
      return false;
    } else {
      return true;
    }
  }

  void initializeMQTTClient() {
    if (!loadModelData()) {
      print('GetStorage returned a empty or null instance');
      return;
    }
    _client = MqttServerClient(
      mqttModel.host,
      mqttModel.identifier,
      maxConnectionAttempts: 1,
    );
    _client.port = int.parse(mqttModel.port); // 8883;
    _client.keepAlivePeriod = mqttModel.keepAlivePeriod; //20;
    _client.onDisconnected = onDisconnected;
    _client.secure = true;
    _client.logging(on: true);
    _client.setProtocolV311();
    _client.autoReconnect = true;

    /// If you do not want active confirmed subscriptions to be
    /// automatically re subscribed by the auto connect sequence do the
    /// following, otherwise leave this defaulted.
    _client.resubscribeOnAutoReconnect = false;

    /// This is the 'pre' auto re connect callback, called before the
    /// sequence starts.
    _client.onAutoReconnect = onAutoReconnect;

    /// This is the 'post' auto re connect callback, called after the
    /// sequencehas completed. Note that re subscriptions may be occurring
    /// when this callback is invoked. See [resubscribeOnAutoReconnect] above.
    _client.onAutoReconnected = onAutoReconnected;

    // Add the successful connection callback
    _client.onConnected = onConnected;
    _client.onSubscribed = onSubscribed;
    _client.pongCallback = pong;
    _client.onSubscribeFail = onSubscribedFailed;
    _client.onUnsubscribed = onUnsubscribed;
    //_client.onBadCertificate = (dynamic a) => true;

    var iat = DateTime.now().millisecondsSinceEpoch / 1000;
    var iatInt = iat.round();
    var exp =
        DateTime.now().add(new Duration(hours: 20)).millisecondsSinceEpoch /
            1000;
    var expInt = exp.round();

    JsonWebTokenClaims claims = JsonWebTokenClaims.fromJson({
      'exp': expInt.toString(),
      'iat': iatInt.toString(),
      'aud': 'sensorstore-5ed33',
    });

    JsonWebSignatureBuilder jBuilder = JsonWebSignatureBuilder();
    jBuilder.jsonContent = claims.toJson();
    // add a key to sign, can only add one for JWT

    var key = JsonWebKey.fromPem(File(rsaFile).readAsStringSync());
    jBuilder.addRecipient(key, algorithm: 'RS256');

    var jws = jBuilder.build();
    var tcs = jws.toCompactSerialization();
    password = tcs.toString();

    //jose

    final context = SecurityContext.defaultContext;
    //context.setTrustedCertificates(controller.rsaFile); //bad pkcs..
    context.usePrivateKey(rsaFile);
    //List<int> bytes = utf8.encode(controller.privateKey());
    //context.usePrivateKeyBytes(bytes);
    _client.securityContext = context;

    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(mqttModel.identifier)
        //.withWillTopic('') //controller.mqttModel.willTopic)
        //.withWillMessage('') //controller.mqttModel.willMessage)
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atMostOnce); //  MqttQos.atLeastOnce);
    print('ims: client connecting....');
    _client.connectionMessage = connMess;
  }

  // Connect to the host
  void connect() async {
    appConnectionState = MqttConnectState.connecting;
    try {
      await _client.connect(username, password);
    } on NoConnectionException catch (e) {
      // Raised by the client when connection fails.
      print('EXAMPLE::client exception - $e');
      _client.disconnect();
    } on SocketException catch (e) {
      // Raised by the socket layer
      print('EXAMPLE::socket exception - $e');
      _client.disconnect();
    }

    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      appConnectionState = MqttConnectState.connected;
      print('iotcore client connected -----------------------');
    } else {
      print('ERROR iotcore client connection failed - disconnecting,' +
          ' state is ${_client.connectionStatus.state}');
      _client.disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client.unsubscribe(mqttModel.topic);
    _client.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    //examples subscribes to published topic?????
    //client.subscribe(pubTopic, MqttQos.exactlyOnce);

    _client.publishMessage(
        mqttModel.topic, MqttQos.atMostOnce, builder.payload);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('ims: Subscription confirmed for topic $topic');
  }

  void onSubscribedFailed(String topic) {
    print('ims: Subscription failed call back $topic');
  }

  /// The unsolicited disconnect callback
  /// The disconnected callback is there to indicate a disconnection if
  /// you need to know this. Disconnections are either
  /// solicited(you have called the disconnect() method on the client) or
  /// unsolicited(the broker has closed the connection).
  /// You can then take appropriate action. Some users do reconnect
  /// in the disconnect callback but I think a better method is to
  /// just set a flag to say disconnection has occurred and use a
  /// timed watchdog task to perform the reconnection.
  void onDisconnected() {
    print('ims: OnDisconnected client callback - Client disconnection');
    if (_client.connectionStatus.returnCode ==
        MqttConnectReturnCode.noneSpecified) {
      print('ims: OnDisconnected callback is solicited, this is correct');
    }
    appConnectionState = MqttConnectState.disconnected;
  }

  /// The successful connect callback
  void onConnected() {
    print('ims: OnConnected callback');

    appConnectionState = MqttConnectState.connected;
    print('ims: client connected....');

    _client.subscribe(mqttModel.topic, MqttQos.atMostOnce);
    print('ims: subscribe to - ${mqttModel.topic}');

    /// The client has a change notifier object(see the Observable class)
    /// which we then listen to to get notifications of published updates
    /// to each subscribed topic.
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      received = pt;
      lastRxMsg = pt;
      lastRxTopic = mqttModel.topic;
      //_currentState.setReceivedText(pt);
      print(
          'ims: Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });
  }

  /// The pre auto re connect callback
  void onAutoReconnect() {
    var status = _client.connectionStatus.returnCode;
    if (status == MqttConnectReturnCode.connectionAccepted)
      appConnectionState = MqttConnectState.connected;
    else
      appConnectionState = MqttConnectState.disconnected;
    print('ims: $status');
    print(
        'ims: onAutoReconnect client callback - Client auto reconnection sequence will start');
  }

  /// The post auto re connect callback
  void onAutoReconnected() {
    var status = _client.connectionStatus.returnCode;
    if (status == MqttConnectReturnCode.connectionAccepted)
      appConnectionState = MqttConnectState.connected;
    else
      appConnectionState = MqttConnectState.disconnected;
    // = MqttConnectReturnCode.values;
    print('ims: $status');
    print(
        'ims: onAutoReconnected client callback - Client auto reconnection sequence has completed');
  }

  void onUnsubscribed(String str) {
    print('ims: onUnsubscribed client callback $str');
  }

  void pong() {
    print('ims: Ping response client callback invoked');
  }
}
