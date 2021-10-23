import 'package:flutter/material.dart';

class TheFamilyPage extends StatefulWidget {
  final String userId;
  TheFamilyPage({this.userId});

  @override
  _TheFamilyPageState createState() => _TheFamilyPageState(userId: userId);
}

class _TheFamilyPageState extends State<TheFamilyPage> {
  String userId;
  _TheFamilyPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
