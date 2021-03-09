import 'dart:async';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ble_cp/BleDeviceSelectionWidget.dart';
import 'package:flutter_spinbox/material.dart';


import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  var DeviceSel = "";


  double maxEvents = 10;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _scrollController = ScrollController();

  void set_max_events(setGamesCount) {
    print("################################");
    print(setGamesCount);
    maxEvents = setGamesCount;
}

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
              SpinBox(
                min: 1,
                max: 20,
                value: 10,
                onChanged: (setGamesCount) => set_max_events(setGamesCount),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: _stopWatchTimer.rawTime.value,
                  builder: (context, snap) {
                    final value = snap.data;
                    final displayTime = StopWatchTimer.getDisplayTime(value, hours: false); // , hours: _isHours);
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                                fontSize: 40,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              /// Lap time.
              Container(
                height: 120,
                margin: const EdgeInsets.all(8),
                child: StreamBuilder<List<StopWatchRecord>>(
                  stream: _stopWatchTimer.records,
                  initialData: _stopWatchTimer.records.value,
                  builder: (context, snap) {

                    final value = snap.data;


                    if (value.isEmpty) {
                      return Container();
                    }
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut);
                    });
                    print('Listen records. $value');

                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final data        = value[index];
                        double timeDiff = 0;

                        if(index > 0) {
                          final data_vorher = value[index-1];
                          timeDiff = (data.rawValue - data_vorher.rawValue) / 1000;
                        }



                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${index + 1} ${data.displayTime} ## $timeDiff',
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              height: 10,
                            )
                          ],
                        );
                      },
                      itemCount: value.length,
                    );
                  },
                ),
              ),


              Text(
                CountDevices,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              Text(
                textMsg,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              Text(
                DeviceSel,
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

  var _timer;

  var counter = 0;
  var countBleDevices = bleDevices.length;

  int randomDevice = 0;
  int lastDevice = 0;

  Random _random = Random();

  void _onEvent(GameEventType type, {int deviceNumber, List<int> bluetoothData, int timerData}) {
    print("type: $type, deviceNumber: $deviceNumber, bluetoothData: $bluetoothData, timerData: $timerData");


    // Define Random Colours
    var randomRed   = _random.nextInt(255);
    var randomGreen = _random.nextInt(255);
    var randomBlue  = _random.nextInt(255);

/*    if (deviceNumber != null && bluetoothData != null && bluetoothData.isNotEmpty && bluetoothData.first == 99) {
      // This Timer will execute the _onEvent after 1 second
      _timer = Timer(Duration(seconds: 1), () => _onEvent(GameEventType.timer, timerData: 25));
    } else if (type == bluetoothData) {
      _timer.cancel();
    }*/

    if (bluetoothData.length == 1 && deviceNumber == lastDevice) { // GameEventType.bluetoothReceived // && deviceNumber == 0
      print("JA in dieser Schleife!!");
      print("Count number of events: $counter");
      counter++;

      // Define a random device:
      randomDevice = _random.nextInt(bleDevices.length);

      //_sendColorToDevice(randomDevice, red: randomRed, green: randomGreen, blue: randomBlue);
      _sendColorToDevice(randomDevice, red: 0, green: 255, blue: 0);
      lastDevice = randomDevice;

      _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
    }

    if(counter == 0) {
      _sendColorToDevice(randomDevice, red: 0, green: 255, blue: 0);
    }

    if(counter == 1) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    }

    if(counter >= maxEvents) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      _sendColorToAllDevices(red: 255, green: 255, blue: 255);
      print("ENDE");
      print("###############################");

      sleep(const Duration(seconds: 3));
      _sendColorToAllDevices(red: 0, green: 0, blue: 0);
      counter = 0;
      randomDevice = 0;
      lastDevice = randomDevice;
      _sendColorToDevice(randomDevice, red: 0, green: 255, blue: 0);
    }


    setState(() {
      textMsg = "Count number of events: $counter";
      CountDevices = "Number of connected devices: $countBleDevices";
      DeviceSel = "Device selected: $randomDevice";
    });
  }
}
