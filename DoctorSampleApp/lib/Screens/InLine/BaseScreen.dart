import 'package:flutter/material.dart';

class BaseScreen extends StatefulWidget {
  Widget body;
  String title;

  BaseScreen({Key? key, required this.body, this.title = "Screen"})
      : super(key: key);

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.body,
    );
  }
}
