import 'package:flutter/material.dart';

import 'Book.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book? book;

  BookDetailsScreen({
    @required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book != null) ...[
              Text(book!.title, style: Theme.of(context).textTheme.headlineMedium),
              Text(book!.author, style: Theme.of(context).textTheme.headlineMedium),
            ],
          ],
        ),
      ),
    );
  }
}
