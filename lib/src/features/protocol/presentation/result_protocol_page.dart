import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ic_app/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:share_plus/share_plus.dart';

class ResultPage extends StatelessWidget {
  final List<Map<String, dynamic>> protocolSteps;
  final double medium;
  final String protocolName;

  const ResultPage(
      {required this.protocolSteps,
      required this.protocolName,
      required this.medium});

  List<List<dynamic>> getConvertedProtocolSteps() {
    List<List<dynamic>> data = [];

    // Add headers as the first row
    data.add(['Etapa', 'Decisao', 'Amplitude', 'Tempo', 'Reversao']);

    // Add data rows
    for (var stepData in protocolSteps) {
      data.add([
        stepData['Passo'] ?? 0,
        stepData['Decisao'],
        stepData['Amplitude'],
        stepData['Tempo'],
        stepData['Reversao'],
      ]);
    }

    return data;
  }

  Future<String> saveDataToCsv() async {
    String csvData =
        const ListToCsvConverter().convert(getConvertedProtocolSteps());

    // Salvando o arquivo CSV
    final directory = await getExternalStorageDirectory();
    if (directory != null) {
      final filePath = '${directory.path}/Resultado-$protocolName.csv';
      await File(filePath).writeAsString(csvData);
      return filePath;
    } else {
      throw Exception('Unable to access directory for saving CSV file.');
    }
  }

  // Função de compartilhar
  void shareCSV() async {
    final filePath = await saveDataToCsv();
    await Share.shareXFiles([XFile(filePath)],
        text: 'Resultado-$protocolName-MediaLimiar-$medium');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TabBarApp(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                shareCSV();
              },
              child: const Text('Compartilhar CSV'),
            ),
            Text(
              'Média Limiar: $medium',
              style: const TextStyle(fontSize: 14),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: protocolSteps.length,
              itemBuilder: (context, index) {
                final stepData = protocolSteps[index];
                final backgroundColor = stepData['Reversao'] == 'Sim'
                    ? const Color.fromRGBO(244, 67, 54, 0.75)
                    : Colors.white;

                return Container(
                  color: backgroundColor, // Define a cor de fundo da ListTile.
                  child: ListTile(
                    title: Text(
                      'Passo: $index',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black, // Cor das letras.
                      ),
                    ),
                    subtitle: Text(
                      'Decisao: ${stepData['Decisao']}, Amplitude ${stepData['Amplitude']}, Tempo ${stepData['Tempo']}, Reversão: ${stepData['Reversao']}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black, // Cor das letras.
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
