import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';


class VibrationSliderScreenAmplitudeColumn extends StatefulWidget {
  @override
  _VibrationSliderScreenAmplitudeColumnState createState() => _VibrationSliderScreenAmplitudeColumnState();
}

class _VibrationSliderScreenAmplitudeColumnState extends State<VibrationSliderScreenAmplitudeColumn> {
  double _hertz = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Vibration amplitude: ${_hertz.toInt()} hertz'),
        Slider(
          value: _hertz,
          min: 0.0,
          max: 255.0,
          divisions: 255,
          onChanged: (value) {
            setState(() {
              _hertz = value;
            });
          },
        ),
        SizedBox(height: 20),
        VibrationButtonAmplitude(hertz: _hertz),
      ],
    );
  }
}


class VibrationButtonAmplitude extends StatelessWidget {
  final double hertz;

  VibrationButtonAmplitude({required this.hertz});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        //Delay of 2 seconds to prevent disturbing the accelerometer when pressing
        Future.delayed(Duration(seconds: 2), () {
          VibrationServiceAmplitude.vibrate(amplitude: hertz.toInt());
        });
      },
      child: Text('Vibrate'),
    );
  }
}

class VibrationServiceAmplitude {
  static void vibrate({required int amplitude}) {
    Vibration.vibrate(amplitude: amplitude);
  }
}