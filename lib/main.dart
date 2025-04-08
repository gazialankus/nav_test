import 'package:flutter/material.dart';

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
    // Option1
    // Android back button works well, pops the topmost page
    // return MaterialApp.router(
    //   title: 'Books App',
    //   routerDelegate: _routerDelegate,
    //   routeInformationParser: _routeInformationParser,
    //   routeInformationProvider: _routeInformationProvider,
    // );

    // Option2
    // Android back button is broken, exits the app
    // return MaterialApp.router(
    //   title: 'Books App',
    //   routerConfig: RouterConfig(
    //     routerDelegate: _routerDelegate,
    //     routeInformationParser: _routeInformationParser,
    //     routeInformationProvider: _routeInformationProvider,
    //   ),
    // );

    // Option3
    // Android back button works again, only after providing a backButtonDispatcher
    return MaterialApp.router(
      title: 'Books App',
      routerConfig: RouterConfig(
        routerDelegate: _routerDelegate,
        routeInformationParser: _routeInformationParser,
        routeInformationProvider: _routeInformationProvider,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );

  }
}

class BookRouterDelegate extends RouterDelegate<BookRoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<BookRoutePath> {
  @override
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
    if (show404) {
      return BookRoutePath.unknown();
    }
    final selectedBook = _selectedBook;
    return selectedBook == null
        ? BookRoutePath.home()
        : BookRoutePath.details(books.indexOf(selectedBook));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BooksListPage(books: books, onTapped: _handleBookTapped,),
      if (show404)
        UnknownPage()
      else if (_selectedBook != null)
        BookDetailsPage(book: _selectedBook!)
    ];
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onDidRemovePage: (page) {
        if (page is BookDetailsPage) {
          _selectedBook = null;
        }
        if (page is UnknownPage) {
          show404 = false;
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BookRoutePath path) async {
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
      _selectedBook = books[path.id!];
    } else {
      _selectedBook = null;
    }

    show404 = false;
  }

  void _handleBookTapped(Book book) {
    _selectedBook = book;
    notifyListeners();
  }
}

class BookRoutePath {
  final int? id;
  final bool isUnknown;

  BookRoutePath.home()
      : id = null,
        isUnknown = false;

  BookRoutePath.details(this.id) : isUnknown = false;

  BookRoutePath.unknown()
      : id = null,
        isUnknown = true;

  bool get isHomePage => id == null;

  bool get isDetailsPage => id != null;

  @override
  String toString() {
    return "BookRoutePath: id=${id} isUnknown=${isUnknown}";
  }
}

class BookRouteInformationParser extends RouteInformationParser<BookRoutePath> {
  @override
  Future<BookRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
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

class UnknownPage extends MaterialPage {
  UnknownPage()
    : super(
        key: ValueKey('UnknownPage'),
        child: Scaffold(appBar: AppBar(), body: Center(child: Text('404!'))),
      );
}

class BooksListPage extends Page {
  const BooksListPage({
    required this.books,
    required this.onTapped,
  });

  final List<Book> books;
  final ValueChanged<Book> onTapped;

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(),
          body: ListView(
            children: [
              for (var book in books)
                ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () => onTapped(book),
                ),
            ],
          ),
        );
      },
    );
  }
}

class BookDetailsPage extends Page {
  final Book? book;

  BookDetailsPage({this.book}) : super(key: ValueKey(book));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (book != null) ...[
                  Text(
                    book!.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    book!.author,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class Book {
  final String title;
  final String author;

  Book(this.title, this.author);
}
