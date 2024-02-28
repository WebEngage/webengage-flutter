import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class ScreenNavigationScreen extends StatefulWidget {
  const ScreenNavigationScreen({Key? key}) : super(key: key);

  @override
  _ScreenNavigationScreenState createState() => _ScreenNavigationScreenState();
}

class _ScreenNavigationScreenState extends State<ScreenNavigationScreen> {
  TextEditingController screenController = TextEditingController();
  TextEditingController screenDataController = TextEditingController();
  Map<String, dynamic> valueDic = {};
  String screenName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Screens'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Row(
                    children: [
                      TextWidget(label: 'Screen'),
                      SizedBox(width: 8.0),
                      Expanded(
                          child: InputTextWidget(
                        label: 'Enter Screen Name',
                        controller: screenController,
                      )),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      screenName = screenController.text;
                      WebEngagePlugin.trackScreen(screenName);
                    },
                    child: Text('Set Screen Name'),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      TextWidget(label: 'Screen Data'),
                      SizedBox(width: 8.0),
                      Expanded(
                          child: InputTextWidget(
                        label: '{"key1": "value1", "key2": "value2"}',
                        controller: screenDataController,
                      )),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      String screenData = screenDataController.text;
                      valueDic = json.decode(screenData);
                      WebEngagePlugin.trackScreen(screenName, valueDic);
                    },
                    child: Text('Set Screen Data'),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AddCustomAttributeText(label: 'Set Custom Screen Event'),
                    ],
                  )
                ]))));
  }
}

class TextWidget extends StatelessWidget {
  final String label;

  const TextWidget({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      child: Text(
        label,
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }
}

class InputTextWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const InputTextWidget({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 40.0,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

Future<void> _showInputDialog(BuildContext context, String label) async {
  String key = '';
  Map<String, dynamic> customValue = {};

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(label),
        contentPadding: EdgeInsets.all(10),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter Screen Name'),
                onChanged: (value) {
                  key = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: '{"key1": "value1", "key2": "value2"}'),
                onChanged: (value) {
                  String customVal = value;
                  customValue = json.decode(customVal);
                },
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              WebEngagePlugin.trackScreen(key, customValue);
            },
            child: Text('Set'),
          ),
        ],
      );
    },
  );
}

class AddCustomAttributeText extends StatelessWidget {
  final String label;

  const AddCustomAttributeText({required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showInputDialog(context, label);
      },
      child: Text(
        label,
        style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontSize: 16.0),
      ),
    );
  }
}
