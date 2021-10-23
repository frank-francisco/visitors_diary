import 'package:flutter/material.dart';

class SupportUsPage extends StatefulWidget {
  final String userId;
  SupportUsPage({this.userId});

  @override
  _SupportUsPageState createState() => _SupportUsPageState(userId: userId);
}

class _SupportUsPageState extends State<SupportUsPage> {
  String userId;
  _SupportUsPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
