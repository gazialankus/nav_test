 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/src/consumer.dart';

import '../data/Book.dart';
import '../pages/BookDetailsPage.dart';
import '../pages/BooksListPage.dart';
import 'BookRoutePath.dart';
import '../pages/UnknownPage.dart';

final bookChoiceProvider = StateProvider<int?>((ref) => null);

// we are a router and our current whereabouts in the app is determined by a BookRoutePath instance
// every item in history as well as stack is a BookRoutePath
class BookRouterDelegate extends RouterDelegate<BookRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final WidgetRef ref;

  Book? _selectedBook;
  bool show404 = false;

  List<Book> books = [
    Book('Left Hand of Darkness', 'Ursula K. Le Guin'),
    Book('Too Like the Lightning', 'Ada Palmer'),
    Book('Kindred', 'Octavia E. Butler'),
  ];

  // delegate is created once in the app state, so there is only one of this
  BookRouterDelegate(this.ref) : navigatorKey = GlobalKey<NavigatorState>() {
    // input to delegate
    // ref.listenManual(some provider, listener);// listen to app state this way and bring that state in to this class.
    ref.listenManual(bookChoiceProvider, (previous, next) {
      print('Book change came from Riverpod: $next');
      final Book? newSelectedBook;
      if (next == null) {
        newSelectedBook = null;
      } else {
        newSelectedBook = books[next];
      }
      if (newSelectedBook != _selectedBook) {
        _selectedBook = newSelectedBook;
        notifyListeners();
      }
    });
    // output from delegate
    // ref.read(bookChoiceProvider.notifier).state = books.indexOf(_selectedBook!);
  }

  void _reflectChoiceToProvider() {
    final selectedBook = _selectedBook;
    final selectedBookIndex = selectedBook == null ? null : books.indexOf(selectedBook);
    ref.read(bookChoiceProvider.notifier).state = selectedBookIndex;
  }


  @override
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
    print("BookRouterDelegate.build with $_selectedBook");
    // TODO convert state to pages
    final pages = [
      BooksListPage(books: books),
      if (show404)
        UnknownPage()
      else if (_selectedBook != null)
        BookDetailsPage(book: _selectedBook!)
    ];
    print("  num pages: ${pages.length}");
    // Can't just use a Consumer here to rebuild the pages, it has to come from Router. 
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
        // you cannot go back to the same book after backing out of it, unless you have this here.
        _reflectChoiceToProvider();
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

      _selectedBook = null;

      // can go through other pages bit by bit.
      // do not need notifyListeners() if no intermediary pages, like this
      // await Future.delayed(Duration(seconds: 3));

      // need notifyListeners() if intermediary pages, like this
      // _selectedBook = books[0];
      // notifyListeners();
      // await Future.delayed(Duration(seconds: 1));
      // _selectedBook = books[1];
      // notifyListeners();
      // await Future.delayed(Duration(seconds: 1));
      // _selectedBook = books[2];
      // notifyListeners();
      // await Future.delayed(Duration(seconds: 1));
      _selectedBook = books[path.id!];
    } else {
      _selectedBook = null;
    }

    show404 = false;

    _reflectChoiceToProvider();
  }

  // moved out to BookListPage, where it belongs. Left as a comment here to compare with the old.
  // void _handleBookTapped(Book book) {
  //   // this is what we would do without Riverpod
  //   // print('BookRouterDelegate._handleBookTapped ${book.title}');
  //   // _selectedBook = book;
  //   // notifyListeners();

  //   // this below is with Riverpod and it works. The change comes to the RouterDelegate from Riverpod
  //   // listenManual in contstructor.
  //   final index = books.indexOf(book);
  //   ref.read(bookChoiceProvider.notifier).state = index == -1 ? null : index;
  // }
}
