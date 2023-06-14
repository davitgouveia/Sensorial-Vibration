import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerDisplay extends StatefulWidget {
  @override
  _AccelerometerDisplayState createState() => _AccelerometerDisplayState();
}

class _AccelerometerDisplayState extends State<AccelerometerDisplay> {
  UserAccelerometerEvent? _userAccelerometerValues;

  @override
  void initState() {
    super.initState();
    // Initialize the accelerometer listener
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      if (mounted) {
        setState(() {
          _userAccelerometerValues = event;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'X: ${_userAccelerometerValues?.x ?? 0}',
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.left,
          ),
          Text(
            'Y: ${_userAccelerometerValues?.y ?? 0}',
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.left,
          ),
          Text(
            'Z: ${_userAccelerometerValues?.z ?? 0}',
            style: const TextStyle(fontSize: 24),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

