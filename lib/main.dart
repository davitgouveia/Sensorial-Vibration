import 'package:flutter/material.dart';
import 'package:ic_app/src/features/accelerometer/presentation/accelerometer_display.dart';
// import 'src/features/slider_vibration_amplitude.dart';
// import 'src/features/slider_vibration_timer.dart';
import 'src/features/vibration/presentation/vibration_controller.dart';
import 'src/features/accelerometer/presentation/accelerometer_data.dart';

void main() => runApp(const TabBarApp());

class TabBarApp extends StatelessWidget {
  const TabBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.home), text: 'Home'),
                Tab(icon: Icon(Icons.analytics), text: 'Análise'),
              ],
            ),
            title: const Text('Teste Sensorial'),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AccelerometerRecorder(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AccelerometerRecorder(),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AccelerometerDisplay(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: VibrationPage(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
