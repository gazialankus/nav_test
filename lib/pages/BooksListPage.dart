import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nav_test/routing/BookRouterDelegate.dart';

import '../data/Book.dart';

class BooksListPage extends Page {
  const BooksListPage({required this.books});

  final List<Book> books;

  void onTapped(Book book, WidgetRef ref) {
    final index = books.indexOf(book);
    ref.read(bookChoiceProvider.notifier).state = index == -1 ? null : index;
  }

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
                Consumer(
                  builder: (context, ref, child) {
                    return ListTile(
                      title: Text(book.title),
                      subtitle: Text(book.author),
                      onTap: () => onTapped(book, ref),
                    );
                  },
                ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return Scaffold(
                          appBar: AppBar(),
                          body: Center(child: Text('This is a new page!')),
                        );
                      },
                    ),
                  );
                },
                child: Text('New page'),
              ),
            ],
          ),
        );
      },
    );
  }
}
