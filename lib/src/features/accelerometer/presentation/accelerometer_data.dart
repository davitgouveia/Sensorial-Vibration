import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerData extends StatefulWidget {
  @override
  _AccelerometerDataState createState() => _AccelerometerDataState();
}

class _AccelerometerDataState extends State<AccelerometerData> {
  // UserAccelerometerEvent? _userAccelerometerValues;

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize the accelerometer listener
  //   userAccelerometerEvents.listen((UserAccelerometerEvent event) {
  //     if (mounted) {
  //       setState(() {
  //         _userAccelerometerValues = event;
  //       });
  //     }
  //   });
  // }

  List<double> xValuesNormal = [];
  List<double> yValuesNormal = [];
  List<double> zValuesNormal = [];

  List<double> xValuesVibrate = [];
  List<double> yValuesVibrate = [];
  List<double> zValuesVibrate = [];

  double xAverageNormal = 0;
  double yAverageNormal = 0;
  double zAverageNormal = 0;
  double xHighestNormal = 0;
  double yHighestNormal = 0;
  double zHighestNormal = 0;
  double xAverageVibrate = 0;
  double yAverageVibrate = 0;
  double zAverageVibrate = 0;
  double xHighestVibrate = 0;
  double yHighestVibrate = 0;
  double zHighestVibrate = 0;

  void startRecording() {
    // Clear the previous values
    xValuesNormal.clear();
    yValuesNormal.clear();
    zValuesNormal.clear();

    xValuesVibrate.clear();
    yValuesVibrate.clear();
    zValuesVibrate.clear();

    DateTime startTime = DateTime.now();
    DateTime endFirstTestTime = startTime.add(const Duration(milliseconds: 5));
    DateTime endSecondTestTime =
        startTime.add(const Duration(milliseconds: 10));

    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      DateTime currentTime = DateTime.now();
      // Check if the current time is within the 10-second range
      if (currentTime.isAfter(startTime) &&
          currentTime.isBefore(endFirstTestTime)) {
        xValuesNormal.add(event.x);
        yValuesNormal.add(event.y);
        zValuesNormal.add(event.z);
        print('test1');
      } else {
        //Adicionar Vibração

        while (currentTime.isBefore(endSecondTestTime)) {
          xValuesVibrate.add(event.x);
          yValuesVibrate.add(event.y);
          zValuesVibrate.add(event.z);
          print('test2');
        }
      }
    });
    processValues();
  }

  double calculateAverage(List<double> values) {
    if (values.isEmpty) return 0.0;
    double sum = values.reduce((value, element) => value + element);
    return sum / values.length;
    print('test3');
  }

  double findHighestValue(List<double> values) {
    if (values.isEmpty) return 0.0;
    return values.reduce((value, element) => value > element ? value : element);
    print('test4');
  }

  void processValues() {
    double xAverageNormal = calculateAverage(xValuesNormal);
    double yAverageNormal = calculateAverage(yValuesNormal);
    double zAverageNormal = calculateAverage(zValuesNormal);

    double xHighestNormal = findHighestValue(xValuesNormal);
    double yHighestNormal = findHighestValue(yValuesNormal);
    double zHighestNormal = findHighestValue(zValuesNormal);

    double xAverageVibrate = calculateAverage(xValuesVibrate);
    double yAverageVibrate = calculateAverage(yValuesVibrate);
    double zAverageVibrate = calculateAverage(zValuesVibrate);

    double xHighestVibrate = findHighestValue(xValuesVibrate);
    double yHighestVibrate = findHighestValue(yValuesVibrate);
    double zHighestVibrate = findHighestValue(zValuesVibrate);
    print('test5');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              startRecording();
            },
            child: Text('Start Recording'),
          ),
          SizedBox(height: 16),
          const Text(
            'Média sem vibração',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('X: ${xAverageNormal.toString()}'),
          Text('Y: ${yAverageNormal.toString()}'),
          Text('Z: ${zAverageNormal.toString()}'),
          SizedBox(height: 16),
          const Text(
            'Maior valor sem vibração',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('X: ${xHighestNormal.toString()}'),
          Text('Y: ${yHighestNormal.toString()}'),
          Text('Z: ${zHighestNormal.toString()}'),
          SizedBox(height: 16),
          const Text(
            'Média com vibração',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('X: ${xAverageVibrate.toString()}'),
          Text('Y: ${yAverageVibrate.toString()}'),
          Text('Z: ${zAverageVibrate.toString()}'),
          SizedBox(height: 16),
          const Text(
            'Maior valor com vibração',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text('X: ${xHighestVibrate.toString()}'),
          Text('Y: ${yHighestVibrate.toString()}'),
          Text('Z: ${zHighestVibrate.toString()}'),
        ],
      ),
    );
  }
}
