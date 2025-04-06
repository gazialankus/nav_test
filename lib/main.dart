import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nav_test/routing/BookRouterDelegate.dart';

import 'routing/BookRouteInformationParser.dart';

void main() {
  runApp(ProviderScope(child: BooksApp()));
}


class BooksApp extends ConsumerStatefulWidget {
  @override
  ConsumerState<BooksApp> createState() => _BooksAppState();
}

class _BooksAppState extends ConsumerState<BooksApp> {
  late final BookRouterDelegate _routerDelegate;
  final BookRouteInformationParser _routeInformationParser = BookRouteInformationParser();
  final RouteInformationProvider _routeInformationProvider = PlatformRouteInformationProvider(
      initialRouteInformation: RouteInformation(
        uri: WidgetsBinding.instance.platformDispatcher.defaultRouteName != '/'
            ? Uri.parse(WidgetsBinding.instance.platformDispatcher.defaultRouteName)
            : Uri.parse('/book/1')
      )
  );

  @override
  void initState() {
    super.initState();
    _routerDelegate = BookRouterDelegate(ref);
  }

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







