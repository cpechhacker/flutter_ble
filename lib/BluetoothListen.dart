import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ble_cp/BleDeviceSelectionWidget.dart';


class BleListenWidget extends StatefulWidget {
  @override
  _BleListenWidget createState() => _BleListenWidget();
}

enum GameEventType { bluetoothReceived, timer }

class _BleListenWidget extends State {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _initializeBleDevices());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('BLE Listen'),
      ),

      body: Container(
        child: Center(


          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("Send Color to All Devices - BLE LISTEN TEST"),
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
    _sendColorToAllDevices(red: 250, green: 0, blue: 0);
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
      _sendColorToDevice(i, red: red, green: green, blue: blue);
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

  void _onEvent(GameEventType type, {int deviceNumber, List<int> bluetoothData, int timerData}) {
    print("type: $type, deviceNumber: $deviceNumber, bluetoothData: $bluetoothData, timerData: $timerData");



/*    if (deviceNumber != null && bluetoothData != null && bluetoothData.isNotEmpty && bluetoothData.first == 99) {
      // This Timer will execute the _onEvent after 1 second
      _timer = Timer(Duration(seconds: 1), () => _onEvent(GameEventType.timer, timerData: 25));
    } else if (type == bluetoothData) {
      _timer.cancel();
    }*/

    if (bluetoothData.length == 1) { // GameEventType.bluetoothReceived // && deviceNumber == 0
      print("JA in dieser Schleife!!");
    }

  }
}
