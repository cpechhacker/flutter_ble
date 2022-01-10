import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ble_cp/BleDeviceSelectionWidget.dart';
import "dart:typed_data";

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
  var textMsg = "";
  String valueString = "Das ist ein Text Test";

  List<double> _bleData;
  double data_output;

  int _counter = 0;

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
                child: Text("Send Color to All Devices - BLE LISTEN TEST CP"),
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
                max: 100,
                activeColor: Colors.green,
                inactiveColor: Colors.green[100],
                label: val.round().toString(),
                divisions: 100,
              ),
              TextField(
                onChanged: (text) {
                  valueString = text;
                },
              ),

              Icon(
                Icons.favorite,
                color: Colors.green[600],
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text('Data: $data_output'),

              FloatingActionButton(
                onPressed: _get_ble_data,
                child: Icon(Icons.gesture)
              ),
              Text('$_counter'),
              Text('Data: $_bleData'),


            ],
          ),

        ),
      ),
    );
  }

  // This code is called when the first button is pressed.
  void _firstButtonPressed() {
    print("Button 'Send Color to All Devices' pressed.");
    var waitingTimeInt = val.toInt();
    print("Slider Value: $waitingTimeInt");
    _sendBleDataToAllDevices(red: 250, green: 0, blue: 0, wait: waitingTimeInt);
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
    setState(() {
      print("BLE Data:");
      //print(bluetoothData);

      Uint8List intBytes = Uint8List.fromList(bluetoothData.toList());
      List<double> floatList = intBytes.buffer.asFloat32List();

      _bleData = floatList;
      print(_bleData);

      data_output = double.parse((_bleData[3]).toStringAsFixed(2));
      // print("type: $type, deviceNumber: $deviceNumber, bluetoothData: $bluetoothData, timerData: $timerData");
    });

  }

  void _get_ble_data( {List<int> bluetoothData}) {
    setState(() {
      _counter++;
    });
  }


}



