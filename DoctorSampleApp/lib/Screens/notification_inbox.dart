import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we_notificationinbox_flutter/we_notificationinbox_flutter.dart';
import 'package:dev_sample_app/WEUtils/WEConstants.dart';
import 'package:we_notificationinbox_flutter/src/we_notification_response.dart';

import '../Models/CustomCell.dart';
import '../Models/cell_model.dart';

class NotificationInbox extends StatefulWidget {
  const NotificationInbox({super.key});

  @override
  _NotificationInboxState createState() => _NotificationInboxState();
}

class _NotificationInboxState extends State<NotificationInbox> {
  final _weNotificationInboxFlutterPlugin = WENotificationinboxFlutter();
  List<dynamic> _notificationList = [];
  List<CellData> cellDataList = [];
  bool _hasNextPage = false;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchNotificationList();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_hasNextPage && !_isLoading) {
          setState(() {
            _isLoading = true;
          });
          fetchNext();
        }
      }
    });
  }

  Future<void> fetchNotificationList() async {
    WENotificationResponse weNotificationResponse =
        await _weNotificationInboxFlutterPlugin.getNotificationList();
    if (weNotificationResponse.isSuccess) {
      Map<String, dynamic> fetchedNotificationList =
          weNotificationResponse.response;
      handleSuccess(fetchedNotificationList, isFetchMore: false);
    } else {
      var errorMessage = weNotificationResponse.errorMessage;
      if (kDebugMode) {
        print(
            "WebEngage-Sample-App: Error while Fetching Notification List \n $errorMessage");
      }
    }
    setState(() {
      _isLoading = false; // Fetching is complete, set loading to false
    });
  }

  Future<void> fetchNext() async {
    Map<String, dynamic> fetchedNotificationList;
    var offset = _notificationList[_notificationList.length - 1];

    WENotificationResponse weNotificationResponse =
        await _weNotificationInboxFlutterPlugin.getNotificationList(
            offsetJSON: offset);
    if (weNotificationResponse.isSuccess) {
      fetchedNotificationList = weNotificationResponse.response;
      handleSuccess(fetchedNotificationList, isFetchMore: true);
    } else {
      var errorMessage = weNotificationResponse.errorMessage;
      if (kDebugMode) {
        print(
            "WebEngage-Sample-App: Error while Fetching Notification List with offset \n $errorMessage");
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void updateCellDataList(int index, String newStatus) {
    setState(() {
      _notificationList[index]["status"] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NotificationInbox'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              handleMenuItemSelected(context, value);
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'readAll',
                child: Text(WEConstants.READ_ALL),
              ),
              const PopupMenuItem<String>(
                value: 'unreadAll',
                child: Text(WEConstants.UNREAD_ALL),
              ),
              const PopupMenuItem<String>(
                value: 'deleteAll',
                child: Text(WEConstants.DELETE_ALL),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_notificationList.isNotEmpty)
            ListView.builder(
              controller: _scrollController,
              itemCount: _notificationList.length,
              itemBuilder: (BuildContext context, int index) {
                final notificationItem = _notificationList[index];
                final Map<String, dynamic> message =
                    notificationItem["message"] ?? {};
                final String title = message["title"] ?? "";
                final String description = message["message"] ?? "";
                final String experimentId =
                    notificationItem["experimentId"] ?? "";
                final String status = notificationItem["status"] ?? "";
                return CustomCell(
                    title: title,
                    description: description,
                    experimentId: experimentId,
                    status: status,
                    inboxMessage: notificationItem,
                    updateStatus: (newStatus) {
                      updateCellDataList(index, newStatus);
                    });
              },
            )
          else if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (!_isLoading)
            const Center(
              child: Text("Sorry! You don't have any Message available!"),
            ),
          if (_isLoading && _notificationList.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: _isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.1),
                      child: Center(
                        child: Transform.scale(
                          scale: 2.0,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : const SizedBox
                      .shrink(), // Hides the spinner when not loading
            ),
        ],
      ),
    );
  }

  void showToastMessage() {
    Fluttertoast.showToast(
      msg: "You have reached the end of the message list!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void handleMenuItemSelected(BuildContext context, String value) {
    switch (value) {
      case 'readAll':
        var cloneNotificationList = _notificationList;
        _weNotificationInboxFlutterPlugin.readAll(_notificationList);
        for (var i = 0; i < cloneNotificationList.length; i++) {
          cloneNotificationList[i]["status"] = WEConstants.READ;
        }
        setState(() {
          _notificationList = cloneNotificationList;
        });
        break;

      case 'unreadAll':
        var _cloneNotificationList = _notificationList;
        _weNotificationInboxFlutterPlugin.unReadAll(_notificationList);
        for (var i = 0; i < _cloneNotificationList.length; i++) {
          _cloneNotificationList[i]["status"] = WEConstants.UNREAD;
        }
        setState(() {
          _notificationList = _cloneNotificationList;
        });
        break;

      case 'deleteAll':
        _weNotificationInboxFlutterPlugin.deleteAll(_notificationList);
        break;
    }
  }

  Future<void> handleSuccess(Map<String, dynamic> notificationList,
      {bool isFetchMore = false}) async {
    List<dynamic> notificationItems =
        List<dynamic>.from(notificationList['messageList']);
    var hasNextPage = (notificationList['hasNext']);

    if (isFetchMore) {
      cellDataList.clear();
    }
    if (!hasNextPage && _notificationList.length > 0) {
      showToastMessage();
    }

    setState(() {
      _notificationList.addAll(notificationItems);
      _hasNextPage = hasNextPage;
    });
  }
}
