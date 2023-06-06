import 'package:flutter/material.dart';
import 'slider_vibration_amplitude.dart';
import 'slider_vibration_timer.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Vibration Demo',
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weber Rinne Test App'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: VibrationSliderScreenTimer(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: VibrationSliderScreenAmplitudeColumn(),
            )
          ],
        ),
      ),
    );
  }
}
