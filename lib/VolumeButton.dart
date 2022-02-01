import 'package:flutter/material.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Home()
    );
  }
}

class Home extends  StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double currentvol = 0.5;
  String buttontype = "none";

  @override
  void initState() {
    Future.delayed(Duration.zero,() async {
      currentvol = await PerfectVolumeControl.getVolume();
      //get current volume

      setState(() {
        //refresh UI
      });
    });

    PerfectVolumeControl.stream.listen((volume) {
      //volume button is pressed,
      // this listener will be triggeret 3 times at one button press

      if(volume != currentvol){ //only execute button type check once time
        if(volume > currentvol){ //if new volume is greater, then it up button
          buttontype = "up";
        }else{ //else it is down button
          buttontype = "down";
        }
      }

      setState(() {
        currentvol = volume;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Listen Volume Button Press"),
          backgroundColor: Colors.redAccent,
        ),

        body: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [

                Text("Current Volumen: $currentvol"),

                Divider(),

                buttontype == "none"?
                Text("No button is pressed yet."):
                Text(buttontype == "up"? "Volume Up Button is Pressed":
                "Volume Down Button is Pressed",
                  style: TextStyle(fontSize: 20),)

              ],
            )
        )

    );
  }
}