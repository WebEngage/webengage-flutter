import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class AttributeWidget extends StatefulWidget {
  @override
  _AttributeWidgetState createState() => _AttributeWidgetState();
}

class _AttributeWidgetState extends State<AttributeWidget> {
  Map<String, String> predefinedMap = {
    'key1': 'value1',
    'key2': 'value2',
    // Add more key-value pairs as needed
  };


  TextEditingController valueController = TextEditingController();
  String resultMessage = '';

  void checkAndMap() {

    String inputValue = valueController.text;
  var message = "";
    try {
      // Get JSON string from the text field
      String jsonString = inputValue.trim();

      // Parse JSON string to Map
      var _jsonMap = json.decode(jsonString);
      WebEngagePlugin.setUserAttributes(_jsonMap);
      message = "$_jsonMap";

    } catch (e) {
      print("$e");
      message = 'Error: $e';

    }


    setState(() {
      resultMessage = message;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: valueController,

            decoration: InputDecoration(labelText: 'Enter Map '),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              checkAndMap();
            },
            child: Text('Map Key-Value'),
          ),
          SizedBox(height: 20),
          Text(resultMessage, style: TextStyle(color: Colors.blue, fontSize: 16)),
        ],
      ),
    );
  }
}