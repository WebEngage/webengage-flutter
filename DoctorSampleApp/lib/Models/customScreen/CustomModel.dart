class CustomModel {
  int listSize = 20;
  List<CustomWidgetData> list = [];
  String screenName = "";
  dynamic screenAttribute = {};
  String event = "";
  bool isRecycledView = false;
  CustomModel();

  factory CustomModel.fromJson(Map<String, dynamic> parsedJson) {
    var customModel = CustomModel();
    customModel.listSize = parsedJson["listSize"] ?? -1;
    customModel.screenName = parsedJson["screenName"] ?? "";
    customModel.event = parsedJson["event"] ?? "";
    customModel.isRecycledView = parsedJson["isRecycledView"] ?? false;
    customModel.screenAttribute = parsedJson["screenAttribute"];
    if (parsedJson["list"] != null) {
      parsedJson["list"].forEach((v) {
        customModel.list.add(CustomWidgetData.fromJson(v));
      });
    }
    return customModel;
    // return new CustomModel(
    //     name: parsedJson['name'] ?? "",
    //     age: parsedJson['age'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "listSize": listSize,
      "event":event,
      "screenName": screenName,
      "isRecycledView":isRecycledView,
      "screenAttribute":screenAttribute,
      "list": list.map<Map<String, dynamic>>((data) => data.toJson()).toList(),
    };
  }
}

class CustomWidgetData {
  int position = -1;
  String androidPropertyId = "";
  int iosPropertyID = -1;
  String screenName = "";
  double viewHeight = -1;
  double viewWidth = -1;
  bool isCustomView = false;

  factory CustomWidgetData.fromJson(Map<String, dynamic> parsedJson) {
    var customData = CustomWidgetData();
    customData.position = parsedJson["position"];
    customData.androidPropertyId = parsedJson["androidPropertyId"];
    customData.iosPropertyID = parsedJson["iosPropertyID"];
    customData.screenName = parsedJson["screenName"];
    customData.viewHeight = parsedJson["viewHeight"];
    customData.viewWidth = parsedJson["viewWidth"];
    customData.isCustomView = parsedJson["isCustomView"] ?? false;
    return customData;
  }

  Map<String, dynamic> toJson() {
    return {
      "position": position,
      "androidPropertyId": androidPropertyId,
      "iosPropertyID": iosPropertyID,
      "screenName": screenName,
      "viewHeight": viewHeight,
      "viewWidth":viewWidth,
      "isCustomView":isCustomView
    };
  }

  CustomWidgetData();
}
