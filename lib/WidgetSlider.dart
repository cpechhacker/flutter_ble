import 'package:flutter/material.dart';

class SliderWidget extends StatefulWidget {
  @override
  _SliderWidget createState() => _SliderWidget();
  }

class _SliderWidget extends State {
  int _value = 6;
  var textMsg = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slider Tutorial',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Slider Tutorial'),
          ),
          body: Padding(
            padding: EdgeInsets.all(15.0),
            child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.ac_unit,
                        size: 30,
                      ),
                      new Expanded(
                          child: Slider(
                              value: _value.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 10,
                              activeColor: Colors.red,
                              inactiveColor: Colors.black,
                              label: 'Set a value',
                              onChanged: (double newValue) {
                                setState(() {
                                  _value = newValue.round();
                                });
                              },
                              semanticFormatterCallback: (double newValue) {
                                return '${newValue.round()} dollars';
                              }
                          ),


                      ),
                    ]
                )
            ),
          )
      ),
    );
  }
}