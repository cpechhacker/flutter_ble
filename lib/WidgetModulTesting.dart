// https://www.fluttercampus.com/guide/239/listen-volume-button-press/#:~:text=When%20the%20Volume%20Up%20button,Volume%20down%20in%20Flutter%20App.
//https://github.com/JiangJuHong/FlutterPerfectVolumeControl
//https://micropython-glenn20.readthedocs.io/en/latest/library/espnow.html

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ble_cp/BleDeviceSelectionWidget.dart';
import 'package:flutter_ble_cp/SelectColours.dart';

class SliderFarbenDrippling extends StatefulWidget {
  @override
  _SliderFarbenDrippling createState() => _SliderFarbenDrippling();
}

enum GameEventType { bluetoothReceived, timer }

class _SliderFarbenDrippling extends State {
  @override
  void initState() {
    super.initState();

    //PerfectVolumeControl.stream.listen((volume) {
    //volume button is pressed,
    // this listener will be triggeret 3 times at one button press
    // });

    Future.delayed(Duration.zero, () => _initializeBleDevices());
  }

  //Todo: This game needs no continous ble connection. So all possible colours should be sent with ble first. ble is only needed, if button "Send Color to All Devices" is pressed
  double sliderVal = 10;
  double decr_time = 0;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Spiel Drippling'),
      ),

      body: Container(
        child: Center(

          // Todo: Modularize this Select random Colors widget
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              buildColours(context),
              sendColours(),

              Text('Zeit bis zum nächsten Event: $sliderVal'),

              Slider(
                value: sliderVal,
                onChanged: (value) {
                  setState(() {
                    sliderVal = value;
                  });
                },
                min: 1,
                max: 100,
                activeColor: Colors.green,
                inactiveColor: Colors.green[100],
                label: sliderVal.round().toString(),
                divisions: 100,
              ),

            ],
          ),
        ),
      ),
    );
  }



  void _initializeBleDevices() {
    print("Available devices: ${bleDevices.length}");

    bleDevices.forEach(
            (device) => device.tx.value.listen((value) => _onEvent(GameEventType.bluetoothReceived, device, value)));
  }

  void _onEvent(GameEventType type, BleDevice device, List<int> bluetoothData) {
  }



}



