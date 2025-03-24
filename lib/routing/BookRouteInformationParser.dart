import 'package:flutter/material.dart';

import 'BookRoutePath.dart';

class BookRouteInformationParser extends RouteInformationParser<BookRoutePath> {
  @override
  Future<BookRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    print('BookRouteInformationParser.parseRouteInformation RouteInformation ${routeInformation.uri}');
    print('  URI TO CONFIGURATION');
    final uri = routeInformation.uri;
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return BookRoutePath.home();
    }

    // Handle '/book/:id'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'book') return BookRoutePath.unknown();
      var remaining = uri.pathSegments[1];
      var id = int.tryParse(remaining);
      if (id == null) return BookRoutePath.unknown();
      return BookRoutePath.details(id);
    }

    // Handle unknown routes
    return BookRoutePath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(BookRoutePath path) {
    print('BookRouteInformationParser.restoreRouteInformation ${path.toString()}');
    print('  CONFIGURATION TO URI');
    if (path.isUnknown) {
      return RouteInformation(uri: Uri.parse('/404'));
    }
    if (path.isHomePage) {
      return RouteInformation(uri: Uri.parse('/'));
    }
    if (path.isDetailsPage) {
      return RouteInformation(uri: Uri.parse('/book/${path.id}'));
    }
    return null;
  }
}
