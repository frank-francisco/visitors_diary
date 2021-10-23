import 'package:flutter/material.dart';

class SwahiliAdvancedPage extends StatefulWidget {
  final String userId;
  SwahiliAdvancedPage({this.userId});

  @override
  _SwahiliAdvancedPageState createState() =>
      _SwahiliAdvancedPageState(userId: userId);
}

class _SwahiliAdvancedPageState extends State<SwahiliAdvancedPage> {
  String userId;
  _SwahiliAdvancedPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
