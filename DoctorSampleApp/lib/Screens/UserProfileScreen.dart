import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool pushChecked = false;
  bool inAppChecked = false;
  bool smsChecked = false;
  bool emailChecked = false;
  bool whatsappChecked = false;
  bool viberChecked = false;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController hashEmailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController hashPhoneController = TextEditingController();
  TextEditingController companyController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  TextWidget(label: 'First Name'),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: InputTextWidget(
                    label: 'First Name',
                    controller: firstNameController,
                  )),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  TextWidget(label: 'Last Name'),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: InputTextWidget(
                          label: 'Last Name', controller: lastNameController)),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  TextWidget(label: 'Email'),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: InputTextWidget(
                          label: 'Email', controller: emailController)),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  TextWidget(label: 'Hashed Email'),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: InputTextWidget(
                    label: 'Hashed Email',
                    controller: hashEmailController,
                  )),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  TextWidget(label: 'Phone'),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: InputTextWidget(
                    label: 'Phone',
                    controller: phoneController,
                  )),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  TextWidget(label: 'Hashed Phone'),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: InputTextWidget(
                    label: 'Hashed Phone',
                    controller: hashPhoneController,
                  )),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  TextWidget(label: 'Company'),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: InputTextWidget(
                    label: 'Company',
                    controller: companyController,
                  )),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  TextWidget(label: 'Birth Date'),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: InputTextWidget(
                    label: 'yyyy-mm-dd',
                    controller: dobController,
                  )),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  TextWidget(label: 'Location'),
                  SizedBox(width: 16.0),
                  Expanded(
                      child: InputTextWidget(
                    label: 'latitude,longitude',
                    controller: locationController,
                  )),
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  TextWidget(label: 'Gender'),
                  SizedBox(width: 16.0),
                  Expanded(child: GenderDropdown()),
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AddCustomAttributeText(label: 'Add'),
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [AddCustomAttributeText(label: 'Delete')],
              ),
              SizedBox(height: 16.0),
              TextWidget(label: 'Opt-In Options'),
              SizedBox(height: 8.0),
              CustomCheckbox(
                label: 'Push',
                value: pushChecked,
                onChanged: (bool? value) {
                  setState(() {
                    pushChecked = value ?? false;
                    WebEngagePlugin.setUserOptIn('push', value ?? false);
                  });
                },
              ),
              CustomCheckbox(
                label: 'In-App',
                value: inAppChecked,
                onChanged: (bool? value) {
                  setState(() {
                    inAppChecked = value ?? false;
                    WebEngagePlugin.setUserOptIn('in_app', value ?? false);
                  });
                },
              ),
              CustomCheckbox(
                label: 'SMS',
                value: smsChecked,
                onChanged: (bool? value) {
                  setState(() {
                    smsChecked = value ?? false;
                    WebEngagePlugin.setUserOptIn('sms', value ?? false);
                  });
                },
              ),
              CustomCheckbox(
                label: 'Email',
                value: emailChecked,
                onChanged: (bool? value) {
                  setState(() {
                    emailChecked = value ?? false;
                    WebEngagePlugin.setUserOptIn('email', value ?? false);
                  });
                },
              ),
              CustomCheckbox(
                label: 'WhatsApp',
                value: whatsappChecked,
                onChanged: (bool? value) {
                  setState(() {
                    whatsappChecked = value ?? false;
                    WebEngagePlugin.setUserOptIn('whatsapp', value ?? false);
                  });
                },
              ),
              CustomCheckbox(
                label: 'Viber',
                value: viberChecked,
                onChanged: (bool? value) {
                  setState(() {
                    viberChecked = value ?? false;
                    WebEngagePlugin.setUserOptIn('viber', value ?? false);
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  String firstName = firstNameController.text;
                  String lastName = lastNameController.text;
                  String email = emailController.text;
                  String hashEmail = hashEmailController.text;
                  String phone = phoneController.text;
                  String hashPhone = hashPhoneController.text;
                  String company = companyController.text;
                  String location = locationController.text;
                  String birthDate = dobController.text;

                  if (firstName.isNotEmpty) {
                    WebEngagePlugin.setUserFirstName(firstName);
                  }

                  if (lastName.isNotEmpty) {
                    WebEngagePlugin.setUserLastName(lastName);
                  }

                  if (email.isNotEmpty) {
                    WebEngagePlugin.setUserEmail(email);
                  }

                  if (hashEmail.isNotEmpty) {
                    WebEngagePlugin.setUserHashedEmail(hashEmail);
                  }

                  if (phone.isNotEmpty) {
                    WebEngagePlugin.setUserPhone(phone);
                  }

                  if (hashPhone.isNotEmpty) {
                    WebEngagePlugin.setUserHashedPhone(hashPhone);
                  }

                  if (birthDate.isNotEmpty) {
                    WebEngagePlugin.setUserBirthDate(birthDate);
                  }

                  if (company.isNotEmpty) {
                    WebEngagePlugin.setUserCompany(company);
                  }

                  if (location.isNotEmpty) {
                    List<String>? locationArray =
                        location.split(',').map((e) => e.trim()).toList();

                    if (locationArray.length == 2) {
                      try {
                        double lat = double.parse(locationArray[0]);
                        double long = double.parse(locationArray[1]);
                        print('latitude $lat & longitude $long');
                        WebEngagePlugin.setUserLocation(lat, long);
                        print('location saved');
                      } catch (e) {
                        showErrorAlert(context, "Incorrect Location format",
                            "Enter location as \"19,72\"");
                      }
                    } else {
                      showErrorAlert(context, "Incorrect Location format",
                          "Enter location as \"19,72\"");
                    }
                  }
                  print("Form submitted successfully!");
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showErrorAlert(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Got It"),
            ),
          ],
        );
      },
    );
  }
}

class TextWidget extends StatelessWidget {
  final String label;

  const TextWidget({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.0,
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
      width: 200.0,
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

class GenderDropdown extends StatefulWidget {
  @override
  _GenderDropdownState createState() => _GenderDropdownState();
}

class _GenderDropdownState extends State<GenderDropdown> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedGender,
      onChanged: (String? value) {
        setState(() {
          _selectedGender = value;
          WebEngagePlugin.setUserGender(value ?? 'other');
        });
      },
      items: ['male', 'female', 'other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      isExpanded: true,
      hint: Text('Select Gender'),
    );
  }
}

class TypeDropdown extends StatefulWidget {
  final ValueChanged<String?> onTypeSelected;

  TypeDropdown({required this.onTypeSelected});

  @override
  _TypeDropdownState createState() => _TypeDropdownState();
}

class _TypeDropdownState extends State<TypeDropdown> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedType,
      onChanged: (String? value) {
        setState(() {
          _selectedType = value;
          widget.onTypeSelected(
              value); // Call the callback with the selected value
        });
      },
      items: ['String', 'Boolean', 'Date', 'Double', 'Dictionary']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      isExpanded: true,
      hint: Text('Select Attribute Type'),
    );
  }
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
        '$label Custom Attribute',
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

Future<void> _showInputDialog(BuildContext context, String label) async {
  String key = '';
  String attributeValue = '';
  String selectedType = '';

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('$label Custom Attribute'),
        contentPadding: EdgeInsets.all(10),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TypeDropdown(
                onTypeSelected: (type) {
                  selectedType = type ?? '';
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Key'),
                onChanged: (value) {
                  key = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Value'),
                onChanged: (value) {
                  attributeValue = value;
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
              print(
                  'Key: $key, Value: $attributeValue, Selected Type: $selectedType');
              setCustomAttributes(
                  context, key, attributeValue, selectedType, label);
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

Future<void> setCustomAttributes(BuildContext context, String key,
    String attributeValue, String attributeType, String label) async {
  switch (attributeType) {
    case 'String':
      WebEngagePlugin.setUserAttribute(key, attributeValue);
      break;

    case 'Double':
      double doubleValue = double.parse(attributeValue);
      WebEngagePlugin.setUserAttribute(key, doubleValue);
      break;

    case 'Boolean':
      bool boolValue = attributeValue.toLowerCase() == 'true';
      WebEngagePlugin.setUserAttribute(key, boolValue);
      break;

    case 'Date':
      DateTime dateValue = DateTime.parse(attributeValue);
      WebEngagePlugin.setUserAttribute(key, attributeValue);
      break;

    case 'Dictionary':
      try {
        String jsonString = attributeValue.trim();
        var _jsonMap = json.decode(jsonString);
        WebEngagePlugin.setUserAttributes(_jsonMap);
      } catch (e) {
        print(
            'Error parsing Dictionary attribute: $key, Value: $attributeValue');
      }
      break;

    default:
      print('Unsupported attribute type: $attributeType');
      break;
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
        padding: EdgeInsets.only(left: 130.0),
        child: CheckboxListTile(
          title: Text(widget.label),
          value: widget.value,
          onChanged: widget.onChanged,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
          tileColor: Colors.transparent,
          dense: true,
          secondary: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: 90.0),
            child: SizedBox(),
          ),
        ),
      ),
    );
  }
}
