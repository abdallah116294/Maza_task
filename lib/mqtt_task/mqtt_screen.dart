import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTService {
  late MqttServerClient client;
  bool isConnected = false; // Track the connection state

  Future<void> connect(Function onConnectedCallback) async {
    client = MqttServerClient('broker.hivemq.com', '');
    client.port = 1883;
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      disconnect();
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      print('MQTT client connected');
      isConnected = true; 
      onConnectedCallback(); 
    } else {
      print('ERROR: MQTT client connection failed - disconnecting, state is ${client.connectionStatus?.state}');
      disconnect();
    }

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      print('Received message: $payload from topic: ${c[0].topic}>');
    });
  }

  void disconnect() {
    client.disconnect();
    print('MQTT client disconnected');
    isConnected = false; 
  }

  void publish(String topic, String message) {
    if (isConnected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
    } else {
      print('Client is not connected. Cannot publish message.');
    }
  }

  void onDisconnected() {
    print('MQTT client disconnected');
    isConnected = false; 
  }
}

class MQTTScreen extends StatefulWidget {
  @override
  _MQTTScreenState createState() => _MQTTScreenState();
}

class _MQTTScreenState extends State<MQTTScreen> {
  final MQTTService mqttService = MQTTService();
  bool isButtonEnabled = false; 

  @override
  void initState() {
       super.initState();
    
    mqttService.connect(() {
      setState(() {
        isButtonEnabled = mqttService.isConnected; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  Scaffold(
        appBar: AppBar(
          title: Text('MQTT Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: isButtonEnabled
                ? () {
                    mqttService.publish('your/topic', 'up');
                  }
                : null, 
            child: Text('Send MQTT Command'),
          ),
        ),
      ),
    );
  }
}