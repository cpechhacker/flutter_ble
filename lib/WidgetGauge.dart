import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


/// Represents the GaugeApp class
class GaugeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Radial Gauge Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

/// Represents MyHomePage class
class MyHomePage extends StatefulWidget {
  /// Creates the instance of MyHomePage
  // ignore: prefer_const_constructors_in_immutables
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


var gaugeAnzeige = 56.4; // StopWatchTimer.getDisplayTime(value, hours: false); // , hours: _isHours);
var gaugeAnzeigeString = gaugeAnzeige.toString();

class _MyHomePageState extends State<MyHomePage> {
  //var GaugeAnzeige = 73.45;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Syncfusion Flutter Radial Gauge')),
        body: SfRadialGauge(
            title: GaugeTitle(
                text: 'Speedometer',
                textStyle: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold)),
            axes: <RadialAxis>[
              RadialAxis(minimum: 0, maximum: 150, ranges: <GaugeRange>[
                GaugeRange(
                    startValue: 0,
                    endValue: 50,
                    color: Colors.green,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 50,
                    endValue: 100,
                    color: Colors.orange,
                    startWidth: 10,
                    endWidth: 10),
                GaugeRange(
                    startValue: 100,
                    endValue: 150,
                    color: Colors.red,
                    startWidth: 10,
                    endWidth: 10)
              ], pointers: <GaugePointer>[
                NeedlePointer(value: gaugeAnzeige)
              ], annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                    widget: Container(
                        child: Text(gaugeAnzeigeString)),
                    angle: gaugeAnzeige,
                    positionFactor: 0.5)
              ])
            ]));
  }
}
