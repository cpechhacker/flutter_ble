import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ble_cp/BleDeviceSelectionWidget.dart';

class GameWidget extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

enum GameEventType { bluetoothReceived, timer }

class _GameState extends State {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _initializeBleDevices());
  }

  var textMsg = "";
  var CountDevices = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Game A'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                CountDevices,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              Text(
                textMsg,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              RaisedButton(
                child: Text("Send Color to All Devices"),
                onPressed: _firstButtonPressed,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  // This code is called when the first button is pressed.
  void _firstButtonPressed() {
    print("Button pressed.");
    _sendColorToAllDevices(red: 0, green: 250, blue: 20);
  }

  void _initializeBleDevices({int red: 250, int green: 30, int blue: 50}) {
    print("Available devices: ${bleDevices.length}");

    for (int i = 0; i < bleDevices.length; i++) {
      var device = bleDevices[i];
      device.tx.value
          .listen((value) => _onEvent(GameEventType.bluetoothReceived, deviceNumber: i, bluetoothData: value));
    }
  }

  void _sendColorToAllDevices({int red: 250, int green: 30, int blue: 50}) {
    for (int i = 0; i < bleDevices.length; i++) {

      var randomRed   = _random.nextInt(255);
      var randomGreen = _random.nextInt(255);
      var randomBlue  = _random.nextInt(255);

      print(randomRed);
      print(randomGreen);

      _sendColorToDevice(i, red: randomRed, green: randomGreen, blue: randomBlue);
    }

    bleDevices.forEach((device) {
      // Do something for alle devices.
    });
  }

  void _sendColorToDevice(int deviceNumber, {int red: 250, int green: 30, int blue: 50}) {
    var color = [red, green, blue];

    if (deviceNumber <= bleDevices.length) {
      var device = bleDevices[deviceNumber];
      try {
        device.rx.write(color, withoutResponse: true);
      } catch (e) {
        print("Could not send color to device: $e");
      }
    } else {
      print("This device ($deviceNumber) doesn't exist.");
    }
  }

  var _timer;

  var counter = 0;
  var countBleDevices = bleDevices.length;

  Random _random = Random();

  void _onEvent(GameEventType type, {int deviceNumber, List<int> bluetoothData, int timerData}) {
    print("type: $type, deviceNumber: $deviceNumber, bluetoothData: $bluetoothData, timerData: $timerData");

    if (deviceNumber != null && bluetoothData != null && bluetoothData.isNotEmpty && bluetoothData.first == 99) {
      // This Timer will execute the _onEvent after 1 second
      _timer = Timer(Duration(seconds: 1), () => _onEvent(GameEventType.timer, timerData: 25));
    } else if (type == bluetoothData) {
      _timer.cancel();
    }

    if (type == bluetoothData && deviceNumber == 0) {
      counter++;
    }

    // Send a color to a random device:
    var randomDevice = _random.nextInt(bleDevices.length);
    _sendColorToDevice(randomDevice, red: 255, green: 0, blue: 0);

    setState(() {
      textMsg = "Count number of events: $counter";
      CountDevices = "Number of connected devices: $countBleDevices";
    });
  }
}
