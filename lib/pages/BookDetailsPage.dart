import 'package:flutter/material.dart';

import '../data/Book.dart';

class BookDetailsPage extends Page {
  final Book? book;

  BookDetailsPage({this.book}) : super(key: ValueKey(book));

  @override
  Route createRoute(BuildContext context) {
    // could also use a PageRouteBuilder with custom animation
    // https://medium.com/flutter/learning-flutters-new-navigation-and-routing-system-7c9068155ade#:~:text=custom%20transition%20animation
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) {
        final tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero);
        final curveTween = CurveTween(curve: Curves.easeInOut);
        return SlideTransition(
          position: animation.drive(curveTween).drive(tween),
          child: Scaffold(
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
          ),
        );
      },
    );
  }
}
