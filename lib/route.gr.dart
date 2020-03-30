// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dns/pages/GetKeyPage.dart';
import 'package:dns/pages/SendDataPage.dart';

abstract class Routes {
  static const getKeyPage = '/';
  static const sendDataPage = '/send-data-page';
}

class Router extends RouterBase {
  //This will probably be removed in future versions
  //you should call ExtendedNavigator.ofRouter<Router>() directly
  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<Router>();

  @override
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.getKeyPage:
        return MaterialPageRoute<dynamic>(
          builder: (_) => GetKeyPage(),
          settings: settings,
        );
      case Routes.sendDataPage:
        if (hasInvalidArgs<SendDataPageArguments>(args)) {
          return misTypedArgsRoute<SendDataPageArguments>(args);
        }
        final typedArgs =
            args as SendDataPageArguments ?? SendDataPageArguments();
        return MaterialPageRoute<dynamic>(
          builder: (_) => SendDataPage(
              key: typedArgs.key, title: typedArgs.title, data: typedArgs.data),
          settings: settings,
        );
      default:
        return unknownRoutePage(settings.name);
    }
  }
}

//**************************************************************************
// Arguments holder classes
//***************************************************************************

//SendDataPage arguments holder class
class SendDataPageArguments {
  final Key key;
  final String title;
  final Map<dynamic, dynamic> data;
  SendDataPageArguments({this.key, this.title, this.data});
}
