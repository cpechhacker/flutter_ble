import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_ble_cp/BleDeviceSelectionWidget.dart';
import "dart:typed_data";
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SliderFarbenDrippling extends StatefulWidget {
  @override
  _SliderFarbenDrippling createState() => _SliderFarbenDrippling();
}

enum GameEventType { bluetoothReceived, timer }

class _SliderFarbenDrippling extends State {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => _initializeBleDevices());
  }

  //Todo: This game needs no continous ble connection. So all possible colours should be sent with ble first. ble is only needed, if button "Send Color to All Devices" is pressed

  List<Color> currentColors = [Color.fromRGBO(255, 0, 0, 0.4)];
  double sliderVal = 10;
  double decr_time = 0;
  Random _random = Random();
  Color randColor = Color.fromRGBO(255, 0, 0, 0.4);

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
              RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Select random colors'),
                        content: SingleChildScrollView(
                          child: MultipleChoiceBlockPicker(
                              pickerColors: currentColors,
                              onColorsChanged: changeColors,
                              availableColors: [

                                Color.fromRGBO(0, 0, 0, 0.4),
                                Color.fromRGBO(255, 255, 255, 0.4),
                                Color.fromRGBO(255, 0, 0, 0.4),
                                Color.fromRGBO(0, 255, 0, 0.4),
                                Color.fromRGBO(0, 0, 255, 0.4),
                                Color.fromRGBO(255, 136, 0, 1),
                                Color.fromRGBO(0, 255, 255, 0.4),
                                Color.fromRGBO(255, 255, 0, 0.4),
                                Color.fromRGBO(255, 0, 255, 0.4)
                              ]),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Wähle mögliche Farben'),
                color: randColor, // currentColors[0],
                textColor: useWhiteForeground(currentColors[0]) ? const Color(0xffffffff) : const Color(0xff000000),

              ),

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

/*              Text('Decretation Time: $decr_time'),
              Slider(
                value: decr_time,
                onChanged: (value) {
                  setState(() {
                    decr_time = value;
                  });
                },
                min: 0,
                max: sliderVal,
                activeColor: Colors.green,
                inactiveColor: Colors.green[100],
                label: decr_time.round().toString(),
                divisions: 100,
              ),*/

              RaisedButton(
                child: Text("Send Color to All Devices"),
                onPressed: _do_color_button_press,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),

            ],
          ),
        ),
      ),
    );
  }



  void changeColors(List<Color> colors) {
    if (colors != null && colors.isNotEmpty) {
      setState(() => currentColors = colors);
    }
    print(currentColors);
  }

  void _initializeBleDevices() {
    print("Available devices: ${bleDevices.length}");

    bleDevices.forEach(
            (device) => device.tx.value.listen((value) => _onEvent(GameEventType.bluetoothReceived, device, value)));
  }

  void _onEvent(GameEventType type, BleDevice device, List<int> bluetoothData) {
    //Color color = _randomColor();
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

  void _do_color_button_press() {
    var waitingTimeInt = sliderVal.toInt();
    Color color = _randomColor();
    _sendBleDataToAllDevices(red: color.red, green: color.green, blue: color.blue, wait: waitingTimeInt);
  }

  Color _randomColor() {
    setState(() {
      print(currentColors);
      int randColorId = _random.nextInt(currentColors.length);
      randColor = currentColors[randColorId];
    });
    return randColor;
  }

}



