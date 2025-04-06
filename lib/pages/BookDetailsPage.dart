import 'package:flutter/material.dart';

import '../data/Book.dart';

class BookDetailsPage extends Page {
  final Book? book;

  BookDetailsPage({this.book}) : super(key: ValueKey(book));

  // iOS back button does not work with this
  // @override
  // Route createRoute(BuildContext context) {
  //   return PageRouteBuilder(
  //     settings: this,
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       final tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero);
  //       final curveTween = CurveTween(curve: Curves.easeInOut);
  //       return SlideTransition(
  //         position: animation.drive(curveTween).drive(tween),
  //         child: Scaffold(
  //           appBar: AppBar(),
  //           body: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 if (book != null) ...[
  //                   Text(book!.title, style: Theme
  //                       .of(context)
  //                       .textTheme
  //                       .headlineMedium),
  //                   Text(book!.author, style: Theme
  //                       .of(context)
  //                       .textTheme
  //                       .headlineMedium),
  //                 ],
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // mac back gesture works
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
                  Text('woo hoo!'),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
