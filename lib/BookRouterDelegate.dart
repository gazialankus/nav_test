import 'package:flutter/material.dart';

import 'Book.dart';
import 'BookDetailsPage.dart';
import 'BookRoutePath.dart';
import 'BooksListScreen.dart';
import 'UnknownScreen.dart';

// we are a router and our current whereabouts in the app is determined by a BookRoutePath instance
// every item in history as well as stack is a BookRoutePath
class BookRouterDelegate extends RouterDelegate<BookRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  Book? _selectedBook;
  bool show404 = false;

  List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin'),
    Book('Too Like the Lightning', 'Ada Palmer'),
    Book('Kindred', 'Octavia E. Butler'),
  ];

  // delegate is created once in the app state, so there is only one of this
  BookRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  BookRoutePath get currentConfiguration {
    print("BookRouterDelegate.currentConfiguration");
    if (show404) {
      return BookRoutePath.unknown();
    }
    final selectedBook = _selectedBook;
    print("  _selectedBook is ${selectedBook == null ? "null" : books.indexOf(selectedBook)}");
    return selectedBook == null
        ? BookRoutePath.home()
        : BookRoutePath.details(books.indexOf(selectedBook));
  }

  @override
  Widget build(BuildContext context) {
    print("BookRouterDelegate.build with ${_selectedBook}");
    final pages = [
      MaterialPage(
        key: ValueKey('BooksListPage'),
        child: BooksListScreen(
          books: books,
          onTapped: _handleBookTapped,
        ),
      ),
      if (show404)
        MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
      else if (_selectedBook != null)
        BookDetailsPage(book: _selectedBook!)
    ];
    print("  num pages: ${pages.length}");
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        print('Navigator.onPopPage imperative pop handled $route $result');
        if (!route.didPop(result)) {
          print('  route did not didPop');
          return false;
        }

        // Update the list of pages by setting _selectedBook to null
        _selectedBook = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  // can override setInitialRoutePath and setRestoredRoutePath but no need
  @override
  Future<void> setInitialRoutePath(BookRoutePath configuration) {
    print("BookRouterDelegate.setInitialRoutePath ${configuration.toString()}");
    return super.setInitialRoutePath(configuration);
  }

  @override
  Future<void> setRestoredRoutePath(BookRoutePath configuration) {
    print("BookRouterDelegate.setRestoredRoutePath ${configuration.toString()}");
    return super.setRestoredRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(BookRoutePath path) async {
    print("BookRouterDelegate.setNewRoutePath ${path.toString()}");
    if (path.isUnknown) {
      _selectedBook = null;
      show404 = true;
      return;
    }

    if (path.isDetailsPage) {
      if (path.id! < 0 || path.id! > books.length - 1) {
        show404 = true;
        return;
      }

      _selectedBook = books[path.id!];
    } else {
      _selectedBook = null;
    }

    show404 = false;
  }

  void _handleBookTapped(Book book) {
    print('BookRouterDelegate._handleBookTapped ${book.title}');
    _selectedBook = book;
    notifyListeners();
  }
}
