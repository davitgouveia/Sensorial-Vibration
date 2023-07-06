import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Criando a classe
class AccelerometerData {
  double x;
  double y;
  double z;
  DateTime timestamp;

  AccelerometerData(this.x, this.y, this.z, this.timestamp);

  List<dynamic> toList() {
    return [x, y, z, timestamp.toIso8601String()];
  }
}

class AccelerometerRecorder extends StatefulWidget {
  @override
  _AccelerometerRecorderState createState() => _AccelerometerRecorderState();
}

class _AccelerometerRecorderState extends State<AccelerometerRecorder> {
  late StreamSubscription<UserAccelerometerEvent> _accelerometerSubscription;
  List<AccelerometerData> _accelerometerDataList = [];

 void startRecording() {
  _accelerometerDataList.clear();

  _accelerometerSubscription = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
    final accelerometerData = AccelerometerData(event.x, event.y, event.z, DateTime.now());
    setState(() {
      _accelerometerDataList.add(accelerometerData);
    });
  });

  Timer(const Duration(seconds: 2), stopRecording);
}

  void stopRecording() {
    _accelerometerSubscription.cancel();
    saveDataToCsv();
  }

  Future<void> saveDataToCsv() async {
    List<List<dynamic>> rows = [];
    rows.add(['X', 'Y', 'Z', 'Timestamp']);

    for (var data in _accelerometerDataList) {
      rows.add(data.toList());
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final directory =
        await getExternalStorageDirectory(); // or getApplicationDocumentsDirectory()
    if (directory != null) {
      final file = File('${directory.path}/accelerometer_data.csv');
      await file.writeAsString(csvData);
      print('Data saved to CSV file ${file}');
    } else {
      print('Unable to access directory for saving CSV file.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          ElevatedButton(
            onPressed: startRecording,
            child: const Text('Start Recording'),
          ),
        ],
      ),
    );
  }
}
