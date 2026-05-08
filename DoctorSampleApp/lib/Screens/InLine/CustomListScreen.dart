import 'package:dev_sample_app/Models/customScreen/CustomModel.dart';
import 'package:dev_sample_app/Screens/InLine/CustomScreen.dart';
import 'package:dev_sample_app/WEUtils/Logger.dart';
import 'package:dev_sample_app/main.dart';
import 'package:dev_sample_app/widgets/CustomViewWidget.dart';
import 'package:dev_sample_app/widgets/SimpleWidget.dart';
import 'package:flutter/material.dart';
import 'package:we_personalization_flutter/we_personalization_flutter.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class CustomListScreen extends StatefulWidget {
  CustomModel customModel;

  CustomListScreen({Key? key, required this.customModel}) : super(key: key);

  @override
  State<CustomListScreen> createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen>
    with WEPlaceholderCallback, RouteAware {
  RegExp _numeric = RegExp(r'^-?[0-9]+$');

  var exceptionText = "";

  /// check if the string contains only numbers
  bool isNumeric(String str) {
    return _numeric.hasMatch(str);
  }

  @override
  void initState() {
    _trackScreen();
    super.initState();
  }

  void _trackScreen() {
    exceptionText = "";
    if ("${widget.customModel.screenAttribute}".isEmpty) {
      WebEngagePlugin.trackScreen(widget.customModel.screenName);
    } else {
      try {
        dynamic value = isNumeric(widget.customModel.screenAttribute)
            ? int.parse(widget.customModel.screenAttribute)
            : widget.customModel.screenAttribute;

        WebEngagePlugin.trackScreen(
            widget.customModel.screenName, {'id': value});
      } catch (e) {
        WebEngagePlugin.trackScreen(widget.customModel.screenName);
      }
    }
    Future.delayed(Duration(milliseconds: 1000), () {
      if (widget.customModel.event.isNotEmpty) {
        WebEngagePlugin.trackEvent(widget.customModel.event);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WEPersonalization()
        .deregisterWEPlaceholderCallback(widget.customModel.screenName);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _trackScreen();
  }

  void _openDialog() {
    print("_openDialog called");
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return CustomInlineScreen(
            isDialog: true,
            hideScreen: widget.customModel.screenName,
          );
        });
  }

  double getWidth() {
    var width = MediaQuery.of(context).size.width - 50;
    return width < 0 ? 0 : width;
  }

  double getHeight() {
    var height = MediaQuery.of(context).size.height - 100;
    return height < 0 ? 0 : height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.customModel.screenName),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              onPressed: () {
                _openDialog();
              },
            )
          ],
        ),
        body: Column(
          children: [
            Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                child: Text("Exception : \n $exceptionText")),
            ElevatedButton(
                onPressed: () {
                  if (widget.customModel.event.isNotEmpty) {
                    WebEngagePlugin.trackEvent(widget.customModel.event);
                  }
                },
                child: Text("EVENT")),
            Expanded(
              child: Container(
                child: !widget.customModel.isRecycledView
                    ? notRecycledView()
                    : Container(
                        padding: const EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: widget.customModel.listSize +
                                widget.customModel.list.length,
                            itemBuilder: (c, i) {
                              int pos = checkIfContains(i);
                              if (pos != -1) {
                                var data = widget.customModel.list[pos];
                                if (data.isCustomView) {
                                  return CustomViewWidget(
                                      customWidgetData: data);
                                } else {
                                  return WEInlineWidget(
                                    screenName: widget.customModel.screenName,
                                    androidPropertyId: data.androidPropertyId,
                                    iosPropertyId: data.iosPropertyID,
                                    viewWidth: data.viewWidth,
                                    viewHeight: data.viewHeight,
                                    placeholderCallback: this,
                                  );
                                }
                              } else {
                                return SimpleWidget(
                                  index: i,
                                  widgetType: i % 2 == 0
                                      ? WidgetType.image
                                      : WidgetType.text,
                                );
                              }
                            })),
              ),
            )
          ],
        ));
  }

  Widget notRecycledView() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: generateChildren(),
        ),
      ),
    );
  }

  List<Widget> generateChildren() {
    var list = <Widget>[];
    list.add(Text("Not Recycled view"));
    int size = widget.customModel.listSize + widget.customModel.list.length;
    for (int i = 0; i < size; i++) {
      int pos = checkIfContains(i);
      if (pos != -1) {
        var data = widget.customModel.list[pos];
        if (data.isCustomView) {
          list.add(CustomViewWidget(customWidgetData: data));
        } else {
          list.add(WEInlineWidget(
            screenName: widget.customModel.screenName,
            androidPropertyId: data.androidPropertyId,
            iosPropertyId: data.iosPropertyID,
            viewWidth: data.viewWidth,
            viewHeight: data.viewHeight,
            placeholderCallback: this,
          ));
        }
      } else {
        list.add(SimpleWidget(
          index: i,
          widgetType: i % 2 == 0 ? WidgetType.image : WidgetType.text,
        ));
      }
    }
    return list;
  }

  @override
  void onDataReceived(data) {
    super.onDataReceived(data);
    Logger.v("onDataReceived : ${data.toJson()}");
  }

  @override
  void onPlaceholderException(
      String campaignId, String targetViewId, String error) {
    super.onPlaceholderException(campaignId, targetViewId, error);

    exceptionText = "$exceptionText Target Id : $targetViewId -> $error \n";
    setState(() {});
    Logger.v("onPlaceholderException : $campaignId $targetViewId $error");
  }

  @override
  void onRendered(data) {
    super.onRendered(data);
    Logger.v("onRendered ${data.toJson()}");
  }

  int checkIfContains(index) {
    var list = widget.customModel.list;
    int count = 0;
    for (var data in list) {
      if (data.position == index) {
        return count;
      }
      count++;
    }
    return -1;
  }
}
