import 'package:flutter/material.dart';
import 'package:ic_app/model/protocols.dart';
import 'package:vibration/vibration.dart';

class RunProtocolPage extends StatefulWidget {
  final Protocols protocol;
  RunProtocolPage({required this.protocol});

  @override
  _RunProtocolPageState createState() => _RunProtocolPageState();
}

void vibrate(int amplitude, int tempo) {
  Vibration.vibrate(duration: tempo, amplitude: amplitude);
}

int decreaseValue(int value, int rate) {
  double percentage = rate / 100.0;
  double decreasedValue = value - (value * percentage);

  return decreasedValue.round();
}

int increaseValue(int value, int rate) {
  double percentage = rate / 100.0;
  double increasedValue = value + (value * percentage);

  return increasedValue.round();
}

class _RunProtocolPageState extends State<RunProtocolPage> {
  bool isProtocolRunning = false;
  late int currentVibration;
  late int currentTime;

  @override
  void initState() {
    super.initState();
    // Initialize the variables here
    currentVibration = widget.protocol.amplitude;
    currentTime = widget.protocol.time;
  }

  void startProtocol() {
    int vibration =
        decreaseValue(currentVibration, widget.protocol.percentageDOWN);
    // Logic to start the test
    setState(() {
      isProtocolRunning = true;
      currentVibration = vibration; // Update the test status
    });
  }

  void stopProtocol() {
    // Logic to stop the test
    setState(() {
      isProtocolRunning = false; // Update the test status
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Executar Protocolo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Protocolo: ${widget.protocol.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              'Amplitude: ${widget.protocol.amplitude}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Tempo: ${widget.protocol.time}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Tipo: ${widget.protocol.type}',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Porcentagem Aumento: ${widget.protocol.percentageUP}%',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Porcentagem Decremento: ${widget.protocol.percentageDOWN}%',
              style: const TextStyle(fontSize: 14),
            ),
            SizedBox(height: 5),
            const Divider(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            Text(
              isProtocolRunning ? 'Protocolo em execução' : 'Protocolo parado',
              style: TextStyle(
                fontSize: 16,
                color: isProtocolRunning ? Colors.green : Colors.red,
              ),
            ),
            Text(
              'Amplitude atual: $currentVibration',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Tempo atual: ${widget.protocol.time}',
              style: const TextStyle(fontSize: 12),
            ),
            const Divider(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            const Text('Resposta do paciente:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle "Sim" button press
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(80),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.green,
                      ),
                    ),
                    child: const Text('Sim', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle "Não" button press
                    },
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(80),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red,
                      ),
                    ),
                    child: const Text('Não', style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isProtocolRunning ? stopProtocol : startProtocol,
                    child: Text(isProtocolRunning ? 'Parar' : 'Iniciar',
                        style: const TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle "Next" button press
                    },
                    child: const Text('Próxima etapa',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
