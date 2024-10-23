import 'package:flutter/material.dart';

import 'BookRouteInformationParser.dart';
import 'BookRouterDelegate.dart';

void main() {
  runApp(BooksApp());
}


class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  final BookRouterDelegate _routerDelegate = BookRouterDelegate();
  final BookRouteInformationParser _routeInformationParser = BookRouteInformationParser();
  final RouteInformationProvider _routeInformationProvider = PlatformRouteInformationProvider(
      initialRouteInformation: RouteInformation(
        uri: WidgetsBinding.instance.platformDispatcher.defaultRouteName != '/'
            ? Uri.parse(WidgetsBinding.instance.platformDispatcher.defaultRouteName)
            : Uri.parse('/book/1')
      )
  );

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
      title: 'Books App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
      routeInformationProvider: _routeInformationProvider,
    );
  }
}







