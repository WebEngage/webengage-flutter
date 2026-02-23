/// Screen for selecting region and initializing WebEngage SDK.
import 'package:flutter/material.dart';
import 'package:late_init_flutter/platform_helper/platform_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/region_config.dart';
import 'home_screen.dart';

/// Region selection screen widget.
class RegionSelectionScreen extends StatefulWidget {
  @override
  _RegionSelectionScreenState createState() => _RegionSelectionScreenState();
}

/// State for RegionSelectionScreen widget.
class _RegionSelectionScreenState extends State<RegionSelectionScreen> {
  /// Currently selected region configuration.
  RegionConfig? selectedRegion;

  /// Available regions with their WebEngage configurations.
  final List<RegionConfig> regions = [
    RegionConfig(region: "NORTH", licenseCode: "LICENSE_CODE_1", env: "US"),
    RegionConfig(region: "NORTH-EAST", licenseCode: "~LICENSE_CODE_2", env: "US"),
    RegionConfig(region: "SOUTH-EAST", licenseCode: "LICENSE_CODE_3", env: "IN"),
    RegionConfig(region: "SOUTH", licenseCode: "LICENSE_CODE_4", env: "KSA"),
  ];

  /// Handles region selection submission.
  /// Saves configuration and initializes WebEngage SDK.
  void _onSubmit() async {
    if (selectedRegion == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_region', selectedRegion!.region);
    await prefs.setString('license_code', selectedRegion!.licenseCode);
    await prefs.setString('env', selectedRegion!.env);

    await PlatformHelper().initWebEngage(
      selectedRegion!.licenseCode,
      selectedRegion!.env,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Region")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<RegionConfig>(
              hint: const Text("Select Region"),
              value: selectedRegion,
              isExpanded: true,
              items: regions.map((region) {
                return DropdownMenuItem(
                  value: region,
                  child: Text(region.region),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedRegion = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _onSubmit, child: const Text("Continue")),
          ],
        ),
      ),
    );
  }
}
