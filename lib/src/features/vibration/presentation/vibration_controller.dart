import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class VibrationPage extends StatefulWidget {
  @override
  _VibrationPageState createState() => _VibrationPageState();
}

class _VibrationPageState extends State<VibrationPage> {
  int duration = 1000;
  int amplitude = 128;
  bool isVibrating = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Duração: ${duration.toString()} millisegundos'),
          Slider(
            value: duration.toDouble(),
            min: 0.0,
            max: 5000.0,
            onChanged: (value) {
              setState(() {
                duration = value.toInt();
              });
            },
          ),
          SizedBox(height: 16.0),
          Text('Amplitude: ${amplitude.toString()}'),
          Slider(
            value: amplitude.toDouble(),
            min: 0.0,
            max: 255.0,
            onChanged: (value) {
              setState(() {
                amplitude = value.toInt();
              });
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: isVibrating ? null : _startVibration,
            child: Text('Iniciar Vibração'),
          ),
          ElevatedButton(
            onPressed: isVibrating ? null : _stopVibration,
            child: Text('Parar Vibração'),
          ),
        ],
      ),
    );
  }

  Future<void> _startVibration() async {
  bool ?hasVibrator = await Vibration.hasVibrator();
  if (hasVibrator == true) {
    setState(() {
      isVibrating = true;
    });

    Vibration.vibrate(duration: duration, amplitude: amplitude).then((_) {
      setState(() {
        isVibrating = false;
      });
    });
  }
}

  void _stopVibration() {
    Vibration.cancel();
    setState(() {
      isVibrating = false;
    });
  }
}
