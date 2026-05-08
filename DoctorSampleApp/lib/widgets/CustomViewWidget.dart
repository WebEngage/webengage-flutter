import 'dart:io';

import 'package:dev_sample_app/Models/customScreen/CustomModel.dart';
import 'package:dev_sample_app/widgets/customWidgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:we_personalization_flutter/we_personalization_flutter.dart';

class CustomViewWidget extends StatefulWidget {
  CustomWidgetData customWidgetData;

  CustomViewWidget({Key? key, required this.customWidgetData})
      : super(key: key);

  @override
  State<CustomViewWidget> createState() => _CustomViewWidgetState();
}

class _CustomViewWidgetState extends State<CustomViewWidget>
    implements WEPlaceholderCallback {
  var _onDataReceived = "";
  var id = -1;
  WECampaignData? weCampaignData;
  int count = 0;

  @override
  void initState() {
    super.initState();
    id = WEPersonalization().registerWEPlaceholderCallback(
        widget.customWidgetData.androidPropertyId,
        widget.customWidgetData.iosPropertyID,
        widget.customWidgetData.screenName,
        placeholderCallback: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 150,
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Custom View count : ${count}"),
          Text(
              "Property ID : ${Platform.isAndroid ? widget.customWidgetData.androidPropertyId : widget.customWidgetData.iosPropertyID}"),
          Expanded(child: Text("On Data Received - ${_onDataReceived}")),
          _onDataReceived.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomWidgets.button2("Impression", () {
                      weCampaignData?.trackImpression(map: {"1": 1});
                    }),
                    CustomWidgets.button2("click", () {
                      weCampaignData?.trackClick(map: {"2": 2});
                    })
                  ],
                )
              : SizedBox()
        ],
      ),
    );
  }

  @override
  void onDataReceived(WECampaignData data) {
    ++count;
    weCampaignData = data;
    setState(() {
      _onDataReceived = "${data.toJson()}";
    });
  }

  @override
  void dispose() {
    if (id != -1) {
      WEPersonalization().deregisterWEPlaceholderCallbackById(id);
    }
    super.dispose();
  }

  @override
  void onPlaceholderException(
      String campaignId, String targetViewId, String error) {
    setState(() {
      _onDataReceived = "onPlaceholderException $error";
    });
  }

  @override
  void onRendered(WECampaignData data) {}
}
