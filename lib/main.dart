import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nav_test/routing/BookRouterDelegate.dart';

import 'routing/BookRouteInformationParser.dart';

void main() {
  runApp(ProviderScope(child: BooksApp()));
}

class BooksApp extends ConsumerStatefulWidget {
  const BooksApp({super.key});

  @override
  ConsumerState<BooksApp> createState() => _BooksAppState();
}

class _BooksAppState extends ConsumerState<BooksApp> {
  static const initialBookIndex = 1;
  late final BookRouterDelegate _routerDelegate;
  final BookRouteInformationParser _routeInformationParser =
      BookRouteInformationParser();
  final RouteInformationProvider _routeInformationProvider =
      PlatformRouteInformationProvider(
        initialRouteInformation: RouteInformation(
          uri:
              WidgetsBinding.instance.platformDispatcher.defaultRouteName != '/'
                  ? Uri.parse(
                    WidgetsBinding.instance.platformDispatcher.defaultRouteName,
                  )
                  : Uri.parse('/book/$initialBookIndex'),
        ),
      );

  @override
  void initState() {
    super.initState();
    // ref.read(bookChoiceProvider.notifier).state = initialBookIndex;
    _routerDelegate = BookRouterDelegate(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          // everything else here is so we can have the provider displayed on the stack
          MaterialApp.router(
            title: 'Books App',
            routerDelegate: _routerDelegate,
            routeInformationParser: _routeInformationParser,
            routeInformationProvider: _routeInformationProvider,
          ),
          // /everything else here is so we can have the provider displayed on the stack
          Positioned(
            bottom: 0,
            right: 0,
            child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
                var bookChoiceIndex = ref.watch(bookChoiceProvider);
                return Text(
                  '$bookChoiceIndex', 
                  style: TextStyle(color: Colors.red, fontSize: 40),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
