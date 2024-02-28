import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  TextEditingController eventsViewController = TextEditingController();
  int timesValue = 1;
  bool tvChecked = false;
  bool mobileChecked = false;
  bool groceryChecked = false;
  bool clothesChecked = false;
  bool laptopChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Events'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Row(
                    children: [
                      TextWidget(label: 'Events'),
                      SizedBox(width: 8.0),
                      Expanded(
                          child: InputTextWidget(
                        label: 'Enter Event Name',
                        controller: eventsViewController,
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      TextWidget(label: 'Times: '),
                      SizedBox(width: 12.0),
                      DropdownButton<int>(
                          value: timesValue,
                          onChanged: (int? value) {
                            setState(() {
                              timesValue = value!;
                            });
                          },
                          items: List.generate(10, (index) {
                            return DropdownMenuItem<int>(
                              value: index + 1,
                              child: Text('${index + 1}'),
                            );
                          }))
                    ],
                  ),
                  SizedBox(height: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      String eventName = eventsViewController.text;
                      if (eventName.isNotEmpty) {
                        for (int i = 0; i < timesValue; i++) {
                          WebEngagePlugin.trackEvent(eventName);
                        }
                      }
                    },
                    child: Text('Track Event'),
                  ),
                  SizedBox(height: 30.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AddCustomAttributeText(label: 'Track Custom Events'),
                    ],
                  ),
                  Divider(
                    color:
                        Colors.black, // You can customize the color of the line
                    thickness:
                        1.0, // You can customize the thickness of the line
                    height: 20.0, // You can customize the height of the line
                  ),
                  SizedBox(height: 30.0),
                  Text('Select Product you want to buy: '),
                  SizedBox(height: 10.0),
                  CustomCheckbox(
                    label: 'Television (₹ 30,000)',
                    value: tvChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        tvChecked = value ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  CustomCheckbox(
                    label: 'Mobile (₹ 20,000)',
                    value: mobileChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        mobileChecked = value ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  CustomCheckbox(
                    label: 'Grocery (₹ 1000)',
                    value: groceryChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        groceryChecked = value ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  CustomCheckbox(
                    label: 'Clothes (₹ 3000)',
                    value: clothesChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        clothesChecked = value ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 10.0),
                  CustomCheckbox(
                    label: 'Laptop (₹ 80,000)',
                    value: laptopChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        laptopChecked = value ?? false;
                      });
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (tvChecked) {
                        WebEngagePlugin.trackEvent('Television : 30000');
                      }

                      if (mobileChecked) {
                        WebEngagePlugin.trackEvent('Mobile : 20000');
                      }

                      if (groceryChecked) {
                        WebEngagePlugin.trackEvent('Grocery : 1000');
                      }

                      if (clothesChecked) {
                        WebEngagePlugin.trackEvent('Clothes : 3000');
                      }

                      if (laptopChecked) {
                        WebEngagePlugin.trackEvent('Laptop : 80000');
                      }
                    },
                    child: Text('Buy Items'),
                  ),
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
  Map<String, dynamic> valueDic = {};

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
                decoration: InputDecoration(labelText: 'Key'),
                onChanged: (value) {
                  key = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Value as Dictionary'),
                onChanged: (value) {
                  try {
                    valueDic = json.decode(value);
                    print(valueDic);
                  } catch (e) {
                    print('Invalid JSON format');
                  }
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
              WebEngagePlugin.trackEvent(key, valueDic);
              Navigator.of(context).pop();
            },
            child: Text('Track Custom Event'),
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

class CustomCheckbox extends StatefulWidget {
  final String label;
  final bool value;
  final void Function(bool?) onChanged;

  const CustomCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(left: 90.0),
        child: CheckboxListTile(
          title: Text(widget.label),
          value: widget.value,
          onChanged: widget.onChanged,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          tileColor: Colors.transparent,
          dense: true,
          secondary: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 20.0),
            child: SizedBox(),
          ),
        ),
      ),
    );
  }
}
