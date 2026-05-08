import 'package:flutter/material.dart';
import 'package:dev_sample_app/Models/customScreen/CustomModel.dart';
import 'package:dev_sample_app/Screens/InLine/CustomListScreen.dart';
import 'package:dev_sample_app/Screens/InLine/DeepLinkScreen.dart';
import 'package:dev_sample_app/WEUtils/Utils.dart';

class ScreenNavigator {
  static const SCREEN_HOME = "screen_home_1";
  static const SCREEN_LIST = "screen_list";
  static const SCREEN_DETAIL = "screen_detail_123";
  static const SCREEN_CUSTOM = "screen_custom_123";

  static void gotoListScreen(context) {
    _gotoScreen(context, SCREEN_LIST);
  }

  static void gotoDetailScreen(context) {
    _gotoScreen(context, SCREEN_DETAIL);
  }

  static void gotoCustomScreen(context) {
    _gotoScreen(context, SCREEN_CUSTOM);
  }

  static var _context;

  static void gotoCustomListScreen(context, CustomModel customModel) {
    _context = context;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CustomListScreen(customModel: customModel)));
  }

  static void gotoDeepLinkScreen(context, String deeplink) {
    context = _context;
    if (deeplink.contains("https://www.webengage.com/")) {
      Uri uri = Uri.parse(deeplink);
      String lastPathSegment = uri.pathSegments.last;

      var list = Utils.getScreenDataList();
      for (var data in list) {
        if (data.screenName == lastPathSegment) {
          gotoCustomListScreen(context, data);
          return;
        }
      }
    }
  }

  static void _gotoScreen(context, SCREEN_NAME) {
    print("Shubham $SCREEN_NAME");
    Navigator.of(context).pushNamed(SCREEN_NAME);
  }

  static void _showDialog(context, deeplink) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            content: DeepLinkScreen(
              deepLink: "$deeplink",
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("dismiss")),
            ],
          );
        });
  }
}
