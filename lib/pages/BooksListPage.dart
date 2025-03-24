import 'package:flutter/material.dart';

import '../data/Book.dart';

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
