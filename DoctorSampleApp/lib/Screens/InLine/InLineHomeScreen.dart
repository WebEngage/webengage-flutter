import 'dart:ffi';

import 'package:dev_sample_app/Styles/Colors.dart';
import 'package:flutter/material.dart';
import 'package:we_personalization_flutter/we_personalization_flutter.dart';
// import 'package:flutter_personalization_sdk_example/src/widgets/LoginWidget.dart';
import 'package:dev_sample_app/WEUtils/AppColor.dart';
import 'package:dev_sample_app/WEUtils/ScreenNavigator.dart';
import 'package:dev_sample_app/widgets/SimpleWidget.dart';

class InLineHomeScreen extends StatefulWidget {
  const InLineHomeScreen({Key? key}) : super(key: key);

  @override
  State<InLineHomeScreen> createState() => _InLineHomeScreenState();
}

class _InLineHomeScreenState extends State<InLineHomeScreen> {
  int index = 0;
  bool autoHandleClick = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Inline'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            // LoginWidget(),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ), //SizedBox
                Expanded(
                  child: Text(
                    'Auto Handle Inline click',
                    style: TextStyle(fontSize: 17.0),
                  ),
                ), //Text
                SizedBox(width: 10),
                Checkbox(
                  value: this.autoHandleClick,
                  onChanged: (value) {
                    setState(() {
                      autoHandleClick = value as bool;
                    });
                  },
                ),
              ],
            ),

            // sectionView("List Screen", () {
            //   ScreenNavigator.gotoListScreen(context);
            // }),
            // sectionView("Detail Screen", () {
            //   ScreenNavigator.gotoDetailScreen(context);
            // }),
            sectionView("Custom Screen", () {
              ScreenNavigator.gotoCustomScreen(context);
            }),
          ],
        ),
      ),
    );
  }

  Widget sectionView(label, callback) => GestureDetector(
        onTap: callback,
        child: Container(
          decoration: BoxDecoration(
              color: index++ % 2 == 0 ? primaryColor : secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(10),
          child: Center(
              child: Text(
            "$label",
            style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )),
        ),
      );
}
