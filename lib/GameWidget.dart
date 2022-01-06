import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ble_cp/BleDeviceSelectionWidget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
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
    Future.delayed(Duration.zero, () {
      _initializeBleDevices();
      _startGame();
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  final _colorOff = Colors.black;
  final _errorColor = Colors.orange;

  var textMsg = "";
  var countDevices = "";
  var deviceSel = "";

  var maxEvents = 10;
  var eventCounter = -1; // Game hasn't started yet
  BleDevice currentDevice;

  Random _random = Random();

  bool lightTheme = true;
  List<Color> currentColors = [Colors.green[900]];

  void changeColors(List<Color> colors) {
    if (colors != null && colors.isNotEmpty) {
      setState(() => currentColors = colors);
    }
  }

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final _scrollController = ScrollController();

  void setMaxEvents(maxEvents) {
    print('################################\n$maxEvents');
    this.maxEvents = maxEvents;
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
                onChanged: (setGamesCount) => setMaxEvents(setGamesCount),
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
                            style: const TextStyle(fontSize: 40, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            value.toString(),
                            style: const TextStyle(fontSize: 16, fontFamily: 'Helvetica', fontWeight: FontWeight.w400),
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
                      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
                    });
                    print('Listen records. $value');

                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        final data = value[index];
                        double timeDiff = 0;

                        if (index > 0) {
                          final previousData = value[index - 1];
                          timeDiff = (data.rawValue - previousData.rawValue) / 1000;
                        }
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                '${index + 1} ${data.displayTime} ## $timeDiff',
                                style:
                                    const TextStyle(fontSize: 17, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
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
                countDevices,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              Text(
                textMsg,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              Text(
                deviceSel,
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              /*
              RaisedButton(
                elevation: 3.0,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0.0),
                        contentPadding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        content: SingleChildScrollView(
                          child: SlidePicker(
                            pickerColor: currentColor,
                            onColorChanged: changeColor,
                            paletteType: PaletteType.rgb,
                            enableAlpha: false,
                            displayThumbColor: true,
                            showLabel: false,
                            showIndicator: true,
                            indicatorBorderRadius:
                            const BorderRadius.vertical(
                              top: const Radius.circular(25.0),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Change me again RGB'),
                color: currentColor,
                textColor: useWhiteForeground(currentColor)
                    ? const Color(0xffffffff)
                    : const Color(0xff000000),
              ),

               */

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
                                Colors.red[900],
                                Colors.green[900],
                                Colors.lightGreen[900],
                                Colors.blue[900],
                                Color.fromRGBO(0, 0, 0, 0.4),
                                Color.fromRGBO(255, 255, 255, 0.4),
                                Color.fromRGBO(255, 0, 0, 0.4),
                                Color.fromRGBO(0, 255, 0, 0.4),
                                Color.fromRGBO(0, 0, 255, 0.4),
                                Color.fromRGBO(0, 255, 255, 0.4),
                                Color.fromRGBO(255, 255, 0, 0.4),
                                Color.fromRGBO(255, 0, 255, 0.4)
                              ]),
                        ),
                      );
                    },
                  );
                },
                child: const Text('Change me again and select first colour'),
                color: currentColors[0],
                textColor: useWhiteForeground(currentColors[0]) ? const Color(0xffffffff) : const Color(0xff000000),
              ),

              /*
              RaisedButton(
                child: Text("Send Color to All Devices"),
                onPressed: _firstButtonPressed,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
               */

              RaisedButton(
                child: Text("Send Random Color to All Devices"),
                onPressed: _randomColorButtonPressed,
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

  // This code is called when the second button is pressed.
  void _randomColorButtonPressed() {
    print("Random Button pressed.");
    _sendColorToAllDevices(_randomColor());
  }

  void _initializeBleDevices() {
    print("Available devices: ${bleDevices.length}");

    bleDevices.forEach(
        (device) => device.tx.value.listen((value) => _onEvent(GameEventType.bluetoothReceived, device, value)));
  }

  List<int> _colorToRgb(Color c) {
    return [c.red, c.green, c.blue];
  }

  void _sendColorToAllDevices(Color colorNew) {
    bleDevices.forEach((device) => _sendColorToDevice(device, colorNew));
  }

  void _sendColorToDevice(BleDevice device, Color colorNew) async {
    var color = _colorToRgb(colorNew);
    print("COLOR:  ##############################\n$color");

    try {
      device.rx.write(color, withoutResponse: true).catchError((e) async {
        print('Error.  Need to try again.');
        await Future.delayed(const Duration(milliseconds: 50));
        device.rx.write(color, withoutResponse: true).catchError((e) => 'Still got an error.  Giving up.');
      });
    } catch (e) {
      print("Could not send color to device: $e");
    }
  }

  BleDevice _randomDevice() {
    var randDeviceId = _random.nextInt(bleDevices.length);
    return bleDevices[randDeviceId];
  }

  Color _randomColor() {
    var randColorId = _random.nextInt(currentColors.length);
    return currentColors[randColorId];
  }

  void _startNextEvent() {
    bool _ledOnOtherDevice = false;
    var _ledDeviceMapping = <BleDevice, BleDevice>{};

    if (currentDevice != null) {
      _sendColorToDevice(currentDevice, _colorOff);
    }

    eventCounter++;
    currentDevice = _randomDevice();
    if (_ledOnOtherDevice) {
      _sendColorToDevice(_ledDeviceMapping[currentDevice], _randomColor());
    } else {
      _sendColorToDevice(currentDevice, _randomColor());
    }

    if (_stopWatchTimer.isRunning) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
    } else {
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    }
  }

  void _startGame() {
    eventCounter = -1;
    _sendColorToAllDevices(_randomColor());
  }

  void _finishGame() async {
    eventCounter = -2;  // -2 means we are in _finishGame and should ignore all bluetoothEvents
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    _sendColorToAllDevices(Colors.red);
    await Future.delayed(const Duration(seconds: 3));
    _startGame();
  }

  void _blinkError(device) async {
    _sendColorToDevice(device, _errorColor);
    await Future.delayed(const Duration(milliseconds: 300));
    if (currentDevice != device) {
      _sendColorToDevice(device, _colorOff);
    }
  }


  void _onEvent(GameEventType type, BleDevice device, List<int> bluetoothData) {
    print("type: $type, deviceNumber: $device, bluetoothData: $bluetoothData");

    if (bluetoothData.isEmpty || bluetoothData[0] != 1 || eventCounter == -2) {
      // ignore this event
      return;
    }

    // Order of if statements is important!
    if (eventCounter == -1) {
      // Just started.  StopWatch is stopped and a user has pushed any device.
      // Start the "real" events:
      _sendColorToAllDevices(_colorOff);
      _startNextEvent();
    } else if (device != currentDevice) {
      // User pushed the wrong device.
      // Stupid user.  Just ignore this event.
      _blinkError(device);
    } else if (eventCounter >= maxEvents) {
      // Game has finished.
      _finishGame();
    } else {
      // User pushed the correct device.
      _startNextEvent();
    }

    setState(() {
      textMsg = 'Count number of events: $eventCounter';
      countDevices = 'Number of connected devices: ${bleDevices.length}';
      deviceSel = 'Device selected: ${bleDevices.indexOf(currentDevice)}';
    });
  }
}
