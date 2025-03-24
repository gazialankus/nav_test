 import 'package:flutter/material.dart';

import '../data/Book.dart';
import '../pages/BookDetailsPage.dart';
import '../pages/BooksListPage.dart';
import 'BookRoutePath.dart';
import '../pages/UnknownPage.dart';

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
    // TODO convert state to path
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
    // TODO convert state to pages
    final pages = [
      BooksListPage(books: books, onTapped: _handleBookTapped,),
      if (show404)
        UnknownPage()
      else if (_selectedBook != null)
        BookDetailsPage(book: _selectedBook!)
    ];
    print("  num pages: ${pages.length}");
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (page) {
        // TODO change state according to removed page
        print('Navigator.onDidRemovePage already popped ${page.name}, update yourself!');
        print('  CONSUME POPPING OF PAGE TO UPDATE STATE');
        if (page is BookDetailsPage) {
          _selectedBook = null;
        }
        if (page is UnknownPage) {
          show404 = false;
        }
        // not doing notifyListeners() unlike before, does not seem necessary.
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
    // TODO convert path to state
    print("BookRouterDelegate.setNewRoutePath ${path.toString()}");
    print('  CONSUME PATH TO UPDATE STATE');
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
