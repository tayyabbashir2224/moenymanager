import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MyAboutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AboutListTile(),
    );
  }
}

class AboutListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Center(
        child: Text('This App is Still Under Development.'),
      ),
    );
  }

  final logo = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48.0,
      child: Image.asset('assets/images/icon.png'),
    ),
  );
}
