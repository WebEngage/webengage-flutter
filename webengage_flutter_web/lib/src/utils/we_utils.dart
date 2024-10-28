import 'dart:js_util' as js_util;

Map<String, dynamic> convertJsObjectToMap(object) {
  if (object == null) {
    return {};
  }
  var dartObject = js_util.dartify(object);

  return (dartObject as Map).map((key, value) {
    return MapEntry(key.toString(), value as dynamic);
  }).cast<String, dynamic>();
}
