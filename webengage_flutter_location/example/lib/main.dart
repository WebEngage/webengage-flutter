import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('WebEngage Location Example')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              'webengage_flutter_location is a dependency-only plugin.\n\n'
              'It adds the WebEngage Location SDK to your iOS app via SPM. '
              'No Dart API is needed — the native SDK handles location '
              'tracking automatically.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
