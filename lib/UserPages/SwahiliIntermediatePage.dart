import 'package:flutter/material.dart';

class SwahiliIntermediatePage extends StatefulWidget {
  final String userId;
  SwahiliIntermediatePage({this.userId});

  @override
  _SwahiliIntermediatePageState createState() =>
      _SwahiliIntermediatePageState(userId: userId);
}

class _SwahiliIntermediatePageState extends State<SwahiliIntermediatePage> {
  String userId;
  _SwahiliIntermediatePageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
