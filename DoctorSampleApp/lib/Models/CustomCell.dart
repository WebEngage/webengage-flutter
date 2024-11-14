import 'package:flutter/material.dart';
import 'package:we_notificationinbox_flutter/we_notificationinbox_flutter.dart';
import 'package:dev_sample_app/WEUtils/WEConstants.dart';
import 'package:we_notificationinbox_flutter/utils/WELogger.dart';

class CustomCell extends StatefulWidget {
  final String title;
  final String description;
  final String experimentId;
  String status;
  Map<String, dynamic> inboxMessage;

  Function updateStatus;

  CustomCell(
      {super.key,
      required this.title,
      required this.description,
      required this.experimentId,
      required this.status,
      required this.inboxMessage,
      required this.updateStatus});

  @override
  State<CustomCell> createState() => _CustomCellState();
}

class _CustomCellState extends State<CustomCell> {
  String status = "";
  Map<String, dynamic> inboxMessage = {};
  final _weNotificationInboxFlutterPlugin = WENotificationinboxFlutter();

  @override
  void initState() {
    super.initState();
    status = widget.status;
    inboxMessage = Map.from(widget.inboxMessage);
  }

  @override
  Widget build(BuildContext context) {
    if (status != widget.status) {
      setState(() {
        status = widget.status;
      });
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.grey[300],
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Experiment ID: ${widget.experimentId}',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
              Text(
                'Status: ${status}',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      status.toLowerCase() == "read"
                          ? trackUnread(context)
                          : trackRead(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: Text(
                      status.toLowerCase() == "read"
                          ? WEConstants.UNREAD
                          : WEConstants.READ,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      trackClick(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: Text(
                      WEConstants.CLICK,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      trackView(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: Text(
                      WEConstants.VIEW,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      trackDelete(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: const Text(
                      WEConstants.DELETE,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void trackClick(BuildContext context) {
    _weNotificationInboxFlutterPlugin.trackClick(inboxMessage);
    showAlertDialog(context, "Click tracked",
        "Click has been tracked for this notification.");
  }

  void trackView(BuildContext context) {
    _weNotificationInboxFlutterPlugin.trackView(inboxMessage);
    showAlertDialog(context, "View tracked",
        "View has been tracked for this notification.");
  }

  void trackDelete(BuildContext context) {
    _weNotificationInboxFlutterPlugin.markDelete(inboxMessage);
    showAlertDialog(context, "Marked as Deleted",
        "This notification has been marked as deleted.");
  }

  void trackRead(BuildContext context) {
    WELogger.v(
        "MarkRead \nCurrent Status $status \n marking it as : READ \n inboxMessage.status ${inboxMessage["status"]}");
    _weNotificationInboxFlutterPlugin.markRead(inboxMessage);
    widget.updateStatus(WEConstants.READ);
    setState(() {
      inboxMessage["status"] = WEConstants.READ;
    });
  }

  void trackUnread(BuildContext context) {
    WELogger.v(
        "MarkUnRead \n Current Status $status \n marking it as : UNREAD \n inboxMessage.status ${inboxMessage["status"]}");
    _weNotificationInboxFlutterPlugin.markUnread(inboxMessage);
    widget.updateStatus(WEConstants.UNREAD);
    setState(() {
      inboxMessage["status"] = WEConstants.UNREAD;
    });
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(WEConstants.OK),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
