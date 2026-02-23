/// Main entry point for the late_init_flutter application.
/// This app demonstrates late initialization of WebEngage SDK based on region selection.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/home_screen.dart';
import 'screens/region_selection_screen.dart';

/// Application entry point.
void main() {
  runApp(MyApp());
}

/// Root widget of the application.
/// Determines initial route based on whether a region has been selected.
class MyApp extends StatelessWidget {
  /// Checks if a region has been previously selected.
  /// Returns true if 'selected_region' key exists in SharedPreferences.
  Future<bool> _checkIfRegionSelected() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('selected_region');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<bool>(
        future: _checkIfRegionSelected(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          return snapshot.data! ? HomeScreen() : RegionSelectionScreen();
        },
      ),
    );
  }
}
