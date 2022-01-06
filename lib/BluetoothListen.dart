import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ble_cp/BleDeviceSelectionWidget.dart';
import "dart:typed_data";

ff
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

  double val = 6;

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
              ),


              Slider(
                value: val,
                onChanged: (value) {
                  setState(() {
                    val = value;
                  });
                },
                min: 1,
                max: 10,
                activeColor: Colors.green,
              ),

            ],
          ),

        ),
      ),
    );
  }

  // This code is called when the first button is pressed.
  void _firstButtonPressed() {
    print("Button 'Send Color to All Devices' pressed.");
    var waiting_time_int = val.toInt();
    print("Slider Value: $waiting_time_int");
    _sendBleDataToAllDevices(red: 250, green: 0, blue: 0, wait: waiting_time_int);
    //_sendBleDataToAllDevices(red: 250, green: 0, blue: 0, wait: 1);
  }

  void _initializeBleDevices() {
    print("Available devices: ${bleDevices.length}");

    for (int i = 0; i < bleDevices.length; i++) {
      var device = bleDevices[i];
      device.tx.value.listen((listen_value_cp) => _onEvent(GameEventType.bluetoothReceived, deviceNumber: i, bluetoothData: listen_value_cp));

    }
  }

  void _sendBleDataToAllDevices({int red: 250, int green: 30, int blue: 50, int wait: 1}) {  // double wait: 1

    for (int i = 0; i < bleDevices.length; i++) {
      _sendBleDataToDevice(i, red: red, green: green, blue: blue, wait: wait); //
    }

    bleDevices.forEach((device) {
      // Do something for alle devices.
    });
  }
  // Todo let waiting time be a double -> problems with device.rx.write
  void _sendBleDataToDevice(int deviceNumber, {int red: 250, int green: 30, int blue: 50, int wait: 1}) {
    var data = [red, green, blue, wait];

    if (deviceNumber <= bleDevices.length) {
      var device = bleDevices[deviceNumber];
      try {
        device.rx.write(data, withoutResponse: true);
      } catch (e) {
        print("CP: Could not send color to device: $e");
      }
    } else {
      print("This device ($deviceNumber) doesn't exist.");
    }
  }

  void _onEvent(GameEventType type, {int deviceNumber, List<int> bluetoothData}) {  // List<int> bluetoothData
    print("BLE Data:");
    print(bluetoothData);

    // Uint8List intBytes = Uint8List.fromList(bluetoothData.toList());
    // List<double> floatList = intBytes.buffer.asFloat32List();
    // print(floatList);

    // print("type: $type, deviceNumber: $deviceNumber, bluetoothData: $bluetoothData, timerData: $timerData");

  }


}



