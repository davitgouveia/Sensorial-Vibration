import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'dart:async';
// Para manipular CSV
import 'package:csv/csv.dart';
// Para criar arquivo no diretório
import 'package:path_provider/path_provider.dart';
// Para compartilhar arquivos
import 'package:share_plus/share_plus.dart';
import 'package:vibration/vibration.dart';
import 'dart:io';

// Criando a classe de data do acelerometro
class AccelerometerData {
  double x;
  double y;
  double z;
  DateTime timestamp;

  AccelerometerData(this.x, this.y, this.z, this.timestamp);

  List<dynamic> toList() {
    return [x, y, z, timestamp];
  }
}

// Classe de gravação do Acelerometro
class AccelerometerRecorder extends StatefulWidget {
  @override
  _AccelerometerRecorderState createState() => _AccelerometerRecorderState();
}

class _AccelerometerRecorderState extends State<AccelerometerRecorder> {
  late StreamSubscription<dynamic> _accelerometerSubscription;
  List<AccelerometerData> _accelerometerDataList = [];
  bool isRecordingDone = false;

  void startRecording(int selectedAmplitude) async {
    // Limpa a lista para novos testes
    _accelerometerDataList.clear();
    isRecordingDone = false;

    // Quantos segundos o teste ficara parado e vibrando
    const testeCsv = [5000, 10000];
    Vibration.vibrate(pattern: testeCsv, intensities: [0, selectedAmplitude]);

    // Listener
    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );

    _accelerometerSubscription = stream.listen((sensorEvent) {
      setState(() {
        final accelerometerData = AccelerometerData(sensorEvent.data[0],
            sensorEvent.data[1], sensorEvent.data[2], DateTime.now());
        _accelerometerDataList.add(accelerometerData);
      });
    });

    // Alterar a quantidade de acordo com a duração do teste
    Future.delayed(const Duration(seconds: 15), () {
      stopRecording();  
      isRecordingDone = true;
      _accelerometerSubscription.cancel(); // Don't forget to cancel the subscription
    });
      
  }

  void stopRecording() {
    // Para o listener
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

    // Salvando o arquivo CSV
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final filePath =
          '${directory.path}/accelerometer_data-$selectedAmplitude.csv';
      await File(filePath).writeAsString(csvData);
      print('Data saved to CSV file $filePath');
      return filePath;
    } else {
      throw Exception('Unable to access directory for saving CSV file.');
    }
  }

  // Função de compartilhar
  void shareCSV() async {
    final filePath = await saveDataToCsv();

    await Share.shareXFiles([XFile(filePath)],
        text: 'CSV de teste $selectedAmplitude');
  }

  // Definindo a amplitude padrão, para iniciar o teste
  int selectedAmplitude = 128;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Formulario
          Text('Amplitude atual: $selectedAmplitude'),
          TextField(
            onChanged: (value) {
              setState(() {
                int parsedValue = int.tryParse(value) ?? 1;
                selectedAmplitude = parsedValue.clamp(1, 255);
              });
            },
            decoration: const InputDecoration(
              labelText: 'Digite a Amplitude (1-255)',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
          ),
          //Botões
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
              onPressed: () {
                startRecording(selectedAmplitude);
              },
              child: const Text('Começar Gravação de Acelerometro'),
            ),
          ),
          ElevatedButton(
            onPressed: isRecordingDone ? shareCSV : null,
            child: const Text('Compartilhar CSV'),
          ),
        ],
      ),
    );
  }
}
