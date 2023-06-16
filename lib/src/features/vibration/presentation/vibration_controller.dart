import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class VibrationPage extends StatefulWidget {
  @override
  _VibrationPageState createState() => _VibrationPageState();
}

class _VibrationPageState extends State<VibrationPage> {
  //Default values
  int duration = 1000;
  int amplitude = 128;
  bool isStartButtonEnabled = true;
  bool isStopButtonEnabled = false;

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
          const SizedBox(height: 16.0),
          Text('Amplitude: ${amplitude.toString()}'),
          Slider(
            value: amplitude.toDouble(),
            min: 1.0,
            max: 255.0,
            onChanged: (value) {
              setState(() {
                amplitude = value.toInt();
              });
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: isStartButtonEnabled ? _startVibration : null,
            child: const Text('Iniciar Vibração'),
          ),
          ElevatedButton(
            onPressed: isStopButtonEnabled ? _stopVibration : null,
            child: const Text('Parar Vibração'),
          ),
          ElevatedButton(
            onPressed: _testeVibracao,
            child: const Text('Teste Vibração'),
          ),
        ],
      ),
    );
  }

  Future<void> _startVibration() async {
    bool? hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      setState(() {
        isStartButtonEnabled = false;
        isStopButtonEnabled = true;
      });

      Vibration.vibrate(duration: duration, amplitude: amplitude).then((_) {
        setState(() {
          isStartButtonEnabled = false;
        });
      });

      print('teste');

      //setState to return buttons to original state after vibration ends
      Future.delayed(Duration(milliseconds: duration), () {
        setState(() {
          isStartButtonEnabled = true;
          isStopButtonEnabled = false;
        });
      });
    }
  }

  void _stopVibration() {
    Vibration.cancel();
    setState(() {
      isStopButtonEnabled = false;
      isStartButtonEnabled = true;
    });
  }

  //Initial tests with vibration patterns
  void _testeVibracao() {
    const teste = [2000, 2000, 2000, 2000, 2000, 2000];
    Vibration.vibrate(pattern: teste, intensities: [255,128,64,32,16,4]);
    print('teste');
  }
}
