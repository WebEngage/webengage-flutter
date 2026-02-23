/// Home screen displaying selected region configuration.
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../platform_helper/platform_helper.dart';
import 'region_selection_screen.dart';

/// Home screen widget shown after region selection.
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// State for HomeScreen widget.
class _HomeScreenState extends State<HomeScreen> {
  /// Selected region identifier.
  String region = "";
  
  /// License code for the selected region.
  String lc = "";
  
  /// Environment identifier.
  String env = "";

  @override
  void initState() {
    super.initState();
    _loadRegion();
  }

  /// Loads saved region configuration from SharedPreferences.
  Future<void> _loadRegion() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      region = prefs.getString('selected_region') ?? "";
      lc = prefs.getString('license_code') ?? "";
      env = prefs.getString('env') ?? "";
    });
  }

  /// Logs out user by clearing region data and navigating to region selection.
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear only region-related data
    await prefs.remove('selected_region');
    await prefs.remove('license_code');
    await prefs.remove('env');

    await PlatformHelper().clearData();

    // Navigate to RegionSelectionScreen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => RegionSelectionScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body: Center(
        child: Text(
          "Selected Region: $region \n License Code:  $lc \n Environment : $env ",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
