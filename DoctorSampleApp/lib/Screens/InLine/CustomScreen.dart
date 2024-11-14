import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dev_sample_app/Models/customScreen/CustomModel.dart';
import 'package:dev_sample_app/Screens/InLine/BaseScreen.dart';
import 'package:dev_sample_app/widgets/customWidgets/CustomModelWidget.dart';
import 'package:dev_sample_app/WEUtils/Utils.dart';
import 'package:dev_sample_app/WEUtils/ScreenNavigator.dart';

class CustomInlineScreen extends StatefulWidget {
  bool isDialog = false;
  String? hideScreen = null;

  CustomInlineScreen({Key? key, this.isDialog = false, this.hideScreen})
      : super(key: key);

  @override
  State<CustomInlineScreen> createState() => _CustomInlineScreenState();
}

enum ScreenType { list, detail }

class _CustomInlineScreenState extends State<CustomInlineScreen> {
  ScreenType screenType = ScreenType.list;

  List<CustomModel> list = Utils.getScreenDataList();
  CustomModel selectedCustomModel = Utils.getScreenDataList()[0];

  @override
  Widget build(BuildContext context) {
    return widget.isDialog ? _body() : BaseScreen(body: _body());
  }

  Widget _body() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.isDialog
              ? SizedBox()
              : Container(
                  height: 50,
                  color: Colors.blueGrey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      screenType == ScreenType.detail
                          ? IconButton(
                              onPressed: () {
                                if (screenType == ScreenType.detail) {
                                  setState(() {
                                    screenType = ScreenType.list;
                                  });
                                }
                              },
                              icon: Icon(Icons.arrow_back))
                          : SizedBox(),
                      screenType == ScreenType.list
                          ? ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  list.add(CustomModel());
                                });
                              },
                              child: Text("Add Screen"))
                          : SizedBox()
                    ],
                  ),
                ),
          Expanded(
            child: screenType == ScreenType.list
                ? Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, i) {
                          if (list[i].screenName == widget.hideScreen) {
                            return SizedBox();
                          } else {
                            return InkWell(
                              onTap: () {
                                if (widget.isDialog) return;
                                setState(() {
                                  selectedCustomModel = list[i];
                                  screenType = ScreenType.detail;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          "Screen Name : ${list[i].screenName}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (widget.isDialog) {
                                            Navigator.of(context).pop();
                                          }
                                          ScreenNavigator.gotoCustomListScreen(
                                              context, list[i]);
                                        },
                                        child: Text("OPEN"))
                                  ],
                                ),
                              ),
                            );
                          }
                        }),
                  )
                : Container(
                    child: CustomModelWidget(
                      save: _save,
                      customModel: selectedCustomModel,
                    ),
                  ),
          )
        ],
      ),
    );
  }

  void _save(CustomModel customModel) {
    if (!list.contains(customModel)) {
      list.add(customModel);
    }
    Utils.saveScreenDataList(list);
  }
}
