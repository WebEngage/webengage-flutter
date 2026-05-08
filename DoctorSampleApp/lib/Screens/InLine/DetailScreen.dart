import 'package:flutter/material.dart';
import 'package:webengage_flutter/webengage_flutter.dart';
import 'package:we_personalization_flutter/we_personalization_flutter.dart';
import 'package:dev_sample_app/Screens/InLine/BaseScreen.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with WEPlaceholderCallback {
  Widget contWE() {
    return WEInlineWidget(
      screenName: "ET_home",
      androidPropertyId: "flutter_text",
      iosPropertyId: 123,
      viewWidth: 400,
      viewHeight: 200,
      placeholderCallback: this,
    );
  }

  Widget cont(Color color) {
    return Container(
      height: 200,
      width: 400,
      color: color,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              cont(Colors.green),
              cont(Colors.blue),
              cont(Colors.orange),
              cont(Colors.redAccent),
              cont(Colors.black12),
              cont(Colors.green),
              cont(Colors.red),
              contWE(),
              cont(Colors.green),
              cont(Colors.blue),
              cont(Colors.orange),
              cont(Colors.redAccent),
              cont(Colors.black12),
              cont(Colors.green),
              cont(Colors.red),
              cont(Colors.green),
              cont(Colors.blue),
              cont(Colors.orange),
              cont(Colors.redAccent),
              cont(Colors.black12),
              cont(Colors.green),
              cont(Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    WebEngagePlugin.trackScreen("ET_home", null);
    super.initState();
  }
}
