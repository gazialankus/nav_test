import 'package:flutter/material.dart';

class UnknownPage extends MaterialPage {
  UnknownPage()
    : super(
        key: ValueKey('UnknownPage'),
        child: Scaffold(appBar: AppBar(), body: Center(child: Text('404!'))),
      );
}
