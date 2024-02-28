import 'package:flutter/material.dart';
import '../../WEUtils/AppColor.dart';

class CustomWidgets {
  static Widget button(label, callback) => GestureDetector(
        onTap: callback,
        child: Container(
          decoration: const BoxDecoration(
              color: blue, borderRadius: BorderRadius.all(Radius.circular(20))),
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

  static Widget button2(label, callback) => GestureDetector(
        onTap: callback,
        child: Container(
          decoration: const BoxDecoration(
              color: blue, borderRadius: BorderRadius.all(Radius.circular(20))),
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          margin: const EdgeInsets.all(10),
          child: Center(
              child: Text(
            "$label",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          )),
        ),
      );
}
