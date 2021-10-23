import 'dart:async';
import 'package:afritality/UserPages/AccountSetupPage.dart';
import 'package:afritality/UserPages/GettingStartedScreen.dart';
import 'package:afritality/UserPages/HomePage.dart';
import 'package:afritality/UserPages/SetupProfilePage.dart';
import 'package:afritality/main.dart';
import 'package:afritality/routes/ScaleRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String onlineUserId;
  String _controller;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    manageUser();
    makeDecision();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  makeDecision() {
    _timer = new Timer(
      const Duration(seconds: 5),
      () {
        print('done');
        if (_controller == 'out') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => GettingStartedScreen(),
              ),
              (r) => false);
        } else if (_controller == 'info') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => AccountSetupPage(),
              ),
              (r) => false);
        } else if (_controller == 'home') {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => HomePage(),
              ),
              (r) => false);
        } else if (_controller == null) {
          MyApp.restartApp(context);
        }
      },
    );
  }

  manageUser() async {
    final User user = _auth.currentUser;
    if (user == null) {
      setState(() {
        _controller = 'out';
      });
    } else {
      final snapShot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (snapShot.exists) {
        setState(() {
          _controller = 'home';
        });
      } else {
        setState(() {
          _controller = 'info';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff4da328),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: Image(
                    height: MediaQuery.of(context).size.width / 4.2,
                    //width: 300,
                    fit: BoxFit.contain,
                    image: AssetImage(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.5,
            ),
            Text(
              'The Home\nof\nAfrican Hospitality',
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontSize: 18.0,
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  //color: Colors.black87,
                  letterSpacing: .5,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
