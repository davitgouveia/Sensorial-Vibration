import 'package:flutter/material.dart';
import 'package:ic_app/model/protocols.dart';
import 'package:ic_app/src/features/protocol/presentation/result_protocol_page.dart';
import 'package:vibration/vibration.dart';
import 'package:overlay_support/overlay_support.dart';

class RunProtocolPage extends StatefulWidget {
  final Protocols protocol;
  RunProtocolPage({required this.protocol});

  @override
  _RunProtocolPageState createState() => _RunProtocolPageState();
}

int decreaseValue(int value, int rate) {
  double percentage = rate / 100.0;
  double decreasedValue = value - (value * percentage);
  int finalValue = decreasedValue.round();

  if (finalValue == value && finalValue > 1) {
    finalValue--;
  }

  return finalValue;
}

int increaseValue(int value, int rate, bool testResult) {
  double percentage = rate / 100.0;
  double increasedValue = value + (value * percentage);
  int finalValue = increasedValue.round();

  if (finalValue > 255 && testResult) {
    return 255;
  }
  if (finalValue == value) {
    finalValue++;
  }

  return finalValue;
}

void showAutoDismissNotification(BuildContext context) {
  showSimpleNotification(
    const Text('Notification Title'),
    subtitle: const Text('This notification will disappear in 3 seconds.'),
    background: Colors.red, // Red background color
    autoDismiss: true, // Notification will automatically disappear
    duration: const Duration(
        seconds: 3), // Duration for how long the notification should be visible
  );
}

class _RunProtocolPageState extends State<RunProtocolPage> {
  bool isProtocolRunning = false;
  bool isVibrating = false;
  bool nextStepAvailable = false;

  bool yesAnswerEnabled = false;
  bool noAnswerEnabled = false;

  int currentStep = 0;
  late int currentVibration;
  late int currentTime;
  late String protocolType;
  late int rateUP;
  late int rateDOWN;
  late int reversionsTotal;

  late bool testResult; // True = Amplitude, False = Tempo
  late int mutableValue;

  //Reversão
  int revertionCount = 0;
  String reversion = 'Nao';
  String previousAnswer = 'Inicio';
  bool isFirstDecisionMade = true;

  //Median
  int previousValue = 0;
  List<int> mediumValues = [];
  late double medium;

  List<Map<String, dynamic>> protocolSteps = [];

  @override
  void initState() {
    super.initState();
    currentVibration = widget.protocol.amplitude;
    currentTime = widget.protocol.time;
    protocolType = widget.protocol.type;
    rateUP = widget.protocol.percentageUP;
    rateDOWN = widget.protocol.percentageDOWN;
    reversionsTotal = widget.protocol.reversions;
  }

  bool checkProtocolType(String type) {
    if (type == 'Amplitude') {
      mutableValue = currentVibration;
      return testResult = true;
    } else {
      mutableValue = currentTime;
    }
    return testResult = false;
  }

  void startProtocol() {
    checkProtocolType(protocolType);
    setState(() {
      isProtocolRunning = true;
    });
  }

  void protocolStep() {
    Map<String, dynamic> stepData = {
      'Passo': currentStep,
      'Decisao': previousAnswer,
      'Amplitude': currentVibration,
      'Tempo': currentTime,
      'Reversao': reversion
    };

    protocolSteps.add(stepData);
    currentStep++;

    reversion = 'Nao';

    // Reversoes necessarias para finalizar teste
    if (revertionCount == reversionsTotal) {
      stopProtocol();
    } else {
      setState(() {
        isVibrating = true;
      });

      Vibration.vibrate(duration: currentTime, amplitude: currentVibration)
          .then((_) {
        Future.delayed(Duration(milliseconds: currentTime), () {
          setState(() {
            isVibrating = false;
          });
          enableAnswer(true);
        });
      });

      setState(() {
        currentVibration;
        currentTime;
      });
    }
  }

  void enableAnswer(value) {
    yesAnswerEnabled = value;
    noAnswerEnabled = value;
  }

  void answerYes() {
    setState(() {
      previousValue = mutableValue;
      mutableValue = decreaseValue(mutableValue, rateDOWN);
      String newAnswer = 'Sim';
      testResult
          ? (currentVibration = mutableValue)
          : (currentTime = mutableValue);
      enableAnswer(false);

      if (isFirstDecisionMade == false && newAnswer != previousAnswer) {
        revertionCount++;
        mediumValues.add(previousValue);
        reversion = 'Sim';
      } else {
        isFirstDecisionMade = false;
      }
      previousAnswer = newAnswer;
    });
  }

  void answerNo() {
    setState(() {
      previousValue = mutableValue;
      mutableValue = increaseValue(mutableValue, rateUP, testResult);
      String newAnswer = 'Nao';
      testResult
          ? (currentVibration = mutableValue)
          : (currentTime = mutableValue);
      enableAnswer(false);

      if (isFirstDecisionMade == false && newAnswer != previousAnswer) {
        revertionCount++;
        mediumValues.add(previousValue);
        reversion = 'Sim';
      } else {
        isFirstDecisionMade = false;
      }
      previousAnswer = newAnswer;
    });
  }

  void stopProtocol() {
    setState(() {
      isProtocolRunning = false;
      medium = calcMedium(mediumValues);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          protocolSteps: protocolSteps,
          protocolName: widget.protocol.name,
          medium: medium,
        ),
      ),
    );
  }

  double calcMedium(List<int> numbers) {
    if (numbers.isEmpty) {
      throw Exception("A lista está vazia. A média não pode ser calculada.");
    }

    int sum = 0;
    for (var value in numbers) {
      sum += value;
    }

    return sum / numbers.length.toDouble();
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
            Text(
              'Reversões: ${widget.protocol.reversions}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 5),
            const Divider(
              color: Color.fromRGBO(0, 0, 0, 0.6),
            ),
            Text(
              isProtocolRunning ? 'Protocolo em Execução' : 'Protocolo Parado',
              style: TextStyle(
                fontSize: 16,
                color: isProtocolRunning ? Colors.green : Colors.red,
              ),
            ),
            Visibility(
              visible: isVibrating,
              replacement: const Text(
                'Não Vibrando',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              child: const Text(
                'Vibrando',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
            Text(
              'Amplitude atual: $currentVibration',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Tempo atual: $currentTime',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Total de reversões: $revertionCount',
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
                    onPressed: yesAnswerEnabled
                        ? () => answerYes()
                        : null, // Enable or disable based on yesAnswerEnabled
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(80),
                      ),
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          // Use a different color when the button is disabled
                          return Colors
                              .grey; // Change this to your preferred disabled color
                        }
                        return Colors
                            .green; // Change this to your preferred enabled color
                      }),
                    ),
                    child: const Text('Sim', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: noAnswerEnabled
                        ? () => answerNo()
                        : null, // Enable or disable based on noAnswerEnabled
                    style: ButtonStyle(
                      fixedSize: MaterialStateProperty.all<Size>(
                        const Size.fromHeight(80),
                      ),
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          // Use a different color when the button is disabled
                          return Colors
                              .grey; // Change this to your preferred disabled color
                        }
                        return Colors
                            .red; // Change this to your preferred enabled color
                      }),
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
                  onPressed: () {
                    if (isProtocolRunning && yesAnswerEnabled) {
                      // If the protocol is running and answers are disabled, stop it
                      stopProtocol();
                    } else if (!isProtocolRunning) {
                      // If the protocol is not running, start it
                      startProtocol();
                    }
                  },
                  child: Text(
                    isProtocolRunning ? 'Parar' : 'Iniciar',
                    style: const TextStyle(fontSize: 18),
                  ),
                  // Disable the button if protocol is running and answers are enabled
                )),
                const SizedBox(width: 30),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        isProtocolRunning && !yesAnswerEnabled && !isVibrating
                            ? () => protocolStep()
                            : null,
                    child: const Text('Próximo passo',
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
