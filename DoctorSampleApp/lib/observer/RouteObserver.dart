import 'package:flutter/material.dart';

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  /**
   * This method will get call screen push or pop
   */
  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    if (screenName != null) {
      //print("Tracking screen ${screenName}");
      // WebEngagePlugin.trackScreen(screenName);
    }
  }

  // @override
  // void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
  //   super.didPush(route, previousRoute);
  //   if (route is PageRoute) {
  //     _sendScreenView(route);
  //   }
  // }
  //
  // @override
  // void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
  //   super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  //   if (newRoute is PageRoute) {
  //     _sendScreenView(newRoute);
  //   }
  // }

  // @override
  // void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
  //   super.didPop(route, previousRoute);
  //   if (previousRoute is PageRoute && route is PageRoute) {
  //     _sendScreenView(previousRoute);
  //   }
  // }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
