import 'dart:async';
import 'package:flutter/material.dart';
import "dart:typed_data";
import 'package:syncfusion_flutter_gauges/gauges.dart';

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

  double val = 6;
  var textMsg = "";
  String valueString = "Das ist ein Text Test";

  List<double> _bleData;
  double data_output = 0.0;

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

             SfRadialGauge(
                  title: GaugeTitle(
                      text: 'Speedometer',
                      textStyle: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  axes: <RadialAxis>[
                    RadialAxis(minimum: 0, maximum: 80, ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 30,
                          color: Colors.green,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 30,
                          endValue: 60,
                          color: Colors.orange,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 60,
                          endValue: 80,
                          color: Colors.red,
                          startWidth: 10,
                          endWidth: 10)
                    ], pointers: <GaugePointer>[
                      NeedlePointer(value: data_output)
                    ], annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                              child: Text(data_output.toString())),
                          angle: data_output,
                          positionFactor: 0.5)
                    ])
                  ]),





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
    var waitingTimeDouble = val.toDouble();
    print("Slider Value: $waitingTimeDouble");
    _sendBleDataToAllDevices(red: 250, green: 0, blue: 0, wait: waitingTimeDouble);
    //_sendBleDataToAllDevices(red: 250, green: 0, blue: 0, wait: 1);
  }

  void _initializeBleDevices() {
    print("Available devices: ${bleDevices.length}");

    for (int i = 0; i < bleDevices.length; i++) {
      var device = bleDevices[i];
      device.tx.value.listen((listen_value_cp) => _onEvent(GameEventType.bluetoothReceived, deviceNumber: i, bluetoothData: listen_value_cp));

    }
  }

  void _sendBleDataToAllDevices({int red: 250, int green: 30, int blue: 50, double wait: 1}) {  // double wait: 1

    for (int i = 0; i < bleDevices.length; i++) {
      _sendBleDataToDevice(i, red: red, green: green, blue: blue, wait: wait); //
    }

    bleDevices.forEach((device) {
      // Do something for alle devices.
    });
  }

  List<int> convertDouble32ToBytes(double d) {
    var buffer = Uint8List(3);
    var byteData = buffer.buffer.asByteData();
    byteData.setFloat32(0, d);
    return buffer;
  }

  // Todo let waiting time be a double -> problems with device.rx.write
  void _sendBleDataToDevice(int deviceNumber, {int red: 250, int green: 30, int blue: 50, double wait: 1}) {
    var buffer = Uint8List(6);

    var byteData = buffer.buffer.asByteData();
    byteData.setInt8(0, red);
    byteData.setInt8(1, green);
    byteData.setInt8(2, blue);
    byteData.setFloat32(3, wait);

    //b.addAll(convertDouble32ToBytes(wait))


    if (deviceNumber <= bleDevices.length) {
      var device = bleDevices[deviceNumber];
      try {
        device.rx.write(buffer, withoutResponse: true);
      } catch (e) {
        print("CP: Could not send color to device: $e");
      }
    } else {
      print("This device ($deviceNumber) doesn't exist.");
    }
  }

/*
  void _onEvent(GameEventType type, {int deviceNumber, List<int> bluetoothData}) {  // List<int> bluetoothData
    setState(() {
      print("BLE Data:");
      print(bluetoothData);

      Uint8List intBytes = Uint8List.fromList(bluetoothData.toList());
      List<double> floatList = intBytes.buffer.asFloat32List();


      _bleData = floatList;
      print(_bleData);

      data_output = double.parse((_bleData[3]).toStringAsFixed(2));
      // print("type: $type, deviceNumber: $deviceNumber, bluetoothData: $bluetoothData, timerData: $timerData");
    });
*/


    void _onEvent(GameEventType type, {int deviceNumber, var bluetoothData}) {  // List<int> bluetoothData
      setState(() {
        print("BLE Data:");
        print(bluetoothData);

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



