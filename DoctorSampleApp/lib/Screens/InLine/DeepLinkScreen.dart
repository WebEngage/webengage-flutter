import 'package:flutter/material.dart';

class DeepLinkScreen extends StatefulWidget {

  String deepLink;

   DeepLinkScreen({Key? key,required this.deepLink}) : super(key: key);

  @override
  State<DeepLinkScreen> createState() => _DeepLinkScreenState();
}

class _DeepLinkScreenState extends State<DeepLinkScreen> {

  var text = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    text = widget.deepLink;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      child: Text("$text"),
    );
  }
}
