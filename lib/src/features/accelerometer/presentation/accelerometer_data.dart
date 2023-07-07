import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:numberpicker/numberpicker.dart';

import 'dart:io';

// Criando a classe de escolha de amplitude
class AmplitudePicker extends StatefulWidget {
  @override
  _AmplitudePickerState createState() => _AmplitudePickerState();
}

class _AmplitudePickerState extends State<AmplitudePicker> {
  int selectedAmplitude = 1;

  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      value: selectedAmplitude,
      minValue: 1,
      maxValue: 255,
      itemHeight: 80,
      axis: Axis.horizontal,
      onChanged: (value) {
        setState(() {
          selectedAmplitude = value;
        });
      },
    );
  }
}

// Criando a classe de data do acelerometro
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

    _accelerometerSubscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      final accelerometerData =
          AccelerometerData(event.x, event.y, event.z, DateTime.now());
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

  // Saving data to Csv
  Future<String> saveDataToCsv() async {
    List<List<dynamic>> rows = [];
    rows.add(['X', 'Y', 'Z', 'Timestamp']);

    for (var data in _accelerometerDataList) {
      rows.add(data.toList());
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final filePath = '${directory.path}/accelerometer_data.csv';
      await File(filePath).writeAsString(csvData);
      print('Data saved to CSV file $filePath');
      return filePath;
    } else {
      throw Exception('Unable to access directory for saving CSV file.');
    }
  }

  // Share function
  void shareCSV() async {
    final filePath = await saveDataToCsv();

    await Share.shareXFiles([XFile(filePath)], text: 'CSV de teste');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Valor da amplitude:'),
          AmplitudePicker(),
          ElevatedButton(
            onPressed: startRecording,
            child: const Text('Começar Gravação de Acelerometro'), 
          ),
          ElevatedButton(
            onPressed: shareCSV,
            child: const Text('Compartilhar CSV'),
          ),
        ],
      ),
    );
  }
}
