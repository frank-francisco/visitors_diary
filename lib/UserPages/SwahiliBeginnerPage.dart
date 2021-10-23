import 'package:flutter/material.dart';

class SwahiliBeginnerPage extends StatefulWidget {
  final String userId;
  SwahiliBeginnerPage({this.userId});

  @override
  _SwahiliBeginnerPageState createState() =>
      _SwahiliBeginnerPageState(userId: userId);
}

class _SwahiliBeginnerPageState extends State<SwahiliBeginnerPage> {
  String userId;
  _SwahiliBeginnerPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
