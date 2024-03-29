import 'package:flutter/material.dart';

import 'package:flutter_ble_cp/stopwatch.dart';
import 'package:flutter_ble_cp/WidgetGauge.dart';
import 'package:flutter_ble_cp/WidgetColor.dart';
import 'package:flutter_ble_cp/WidgetLineChart.dart';

import 'package:flutter_ble_cp/BluetoothListen.dart';
import 'package:flutter_ble_cp/WidgetSlider.dart';
import 'package:flutter_ble_cp/ZonenSpiel.dart';
import 'package:flutter_ble_cp/WidgetModulTesting.dart';


class SelectionWidget extends StatefulWidget {
  @override
  _SelectionWidgetState createState() => _SelectionWidgetState();
}


class _SelectionWidgetState extends State {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                child: Text("Stopwatch"),
                onPressed: _startStopwatch,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("Gauge"),
                onPressed: _startGauge,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("Colour"),
                onPressed: _startColour,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("Line Chart"),
                onPressed: _startLineChart,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("Ble Listen"),
                onPressed: _startBleListen,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
/*              RaisedButton(
                child: Text("Slider Testing"),
                onPressed: _startSlider,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              )*/
              RaisedButton(
                child: Text("Farben Drippling"),
                onPressed: _startFarbenDrippling,
                color: Colors.white,
                textColor: Colors.blue,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                splashColor: Colors.grey,
              ),
              RaisedButton(
                child: Text("Zonenspiel"),
                onPressed: _startZonenSpiel,
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



  void _startStopwatch() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>StopwatchWidget()),
    );
  }

  void _startGauge() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>GaugeApp()),
    );
  }

  void _startColour() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>ColorPickerCP()),
    );
  }

  void _startLineChart() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>LineChartApp()),
    );
  }

  void _startBleListen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>BleListenWidget()),
    );
  }

  void _startSlider() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>SliderWidget()),
    );
  }

  void _startFarbenDrippling() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>SliderFarbenDrippling()),
    );
  }

  void _startZonenSpiel() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>SliderZonenSpiel()),
    );
  }


}
