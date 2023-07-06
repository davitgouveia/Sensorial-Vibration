import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:async';
import 'dart:io';

class AccelerometerCapture extends StatefulWidget {
  @override
  _AccelerometerCaptureState createState() => _AccelerometerCaptureState();
}

class _AccelerometerCaptureState extends State<AccelerometerCapture> {
  List<AccelerometerEvent> accelerometerData = [];
  StreamSubscription<AccelerometerEvent>? subscription;
  bool isCapturing = false;

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void startAccelerometerCapture() {
    accelerometerData.clear();

    setState(() {
      isCapturing = true;
    });

    subscription = accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        accelerometerData.add(event);
      });
    });

    Timer(const Duration(seconds: 2), () {
      stopAccelerometerCapture();
    });
  }

  void stopAccelerometerCapture() async {
    subscription?.pause();
    setState(() {
      isCapturing = false;
    });

    String csvData = 'timestamp,x,y,z\n';
    for (AccelerometerEvent event in accelerometerData) {
      String timestamp = DateTime.now().toString();
      csvData += '$timestamp,${event.x},${event.y},${event.z}\n';
    }

    final Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String filePath = '${appDocumentsDirectory.path}/accelerometer_data.csv';

    File file = File(filePath);
    await file.writeAsString(csvData);

    print('Accelerometer data saved to $filePath');

    await OpenFile.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: isCapturing ? null : startAccelerometerCapture,
            child: const Text('Start Capture'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isCapturing ? stopAccelerometerCapture : null,
            child: const Text('Stop Capture'),
          ),
        ],
      ),
    );
  }
}
