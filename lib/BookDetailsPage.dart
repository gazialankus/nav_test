import 'package:flutter/material.dart';

import 'Book.dart';
import 'BookDetailsScreen.dart';

class BookDetailsPage extends Page {
  final Book? book;

  BookDetailsPage({
    this.book,
  }) : super(key: ValueKey(book));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        // TODO why not have the widgets in here?
        // this way I can differentiate between actual pages and mere widgets!
        return BookDetailsScreen(book: book);
      },
    );
  }
}
