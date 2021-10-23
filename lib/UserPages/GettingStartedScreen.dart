import 'package:afritality/UserPages/HomePage.dart';
import 'package:afritality/UserPages/PhoneVerificationPage.dart';
import 'package:afritality/UserPages/Wrapper.dart';
import 'package:afritality/routes/ScaleRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:progress_dialog/progress_dialog.dart';

class GettingStartedScreen extends StatefulWidget {
  @override
  _GettingStartedScreenState createState() => _GettingStartedScreenState();
}

class _GettingStartedScreenState extends State<GettingStartedScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/africa_image.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              colors: [Colors.black, Colors.black.withOpacity(.1)],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    height: 50,
                    image: AssetImage('assets/images/Afritality_logo.png'),
                  ),
                  Container(
                    height: 40,
                    width: 2,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Afritality',
                    style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                        fontSize: 34.0,
                        // fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: .5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'The Home Of African Hospitality',
                style: GoogleFonts.ptSans(
                  textStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              _signInButton(),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => PhoneVerificationPage(),
          ),
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                'Get started',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
