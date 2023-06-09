import 'package:flutter/material.dart';
import 'package:ic_app/src/features/accelerometer/presentation/accelerometer_display.dart';
import 'src/features/slider_vibration_amplitude.dart';
import 'src/features/slider_vibration_timer.dart';

void main() => runApp(TabBarApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Vibration Demo',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Sensory Testing App'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: AccelerometerDisplay(),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: VibrationSliderScreenTimer(),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: VibrationSliderScreenAmplitudeColumn(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

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
                      child: VibrationSliderScreenTimer(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: VibrationSliderScreenAmplitudeColumn(),
                    )
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
