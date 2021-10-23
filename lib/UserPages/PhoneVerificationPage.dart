import 'package:afritality/UserPages/CompleteVerificationPage.dart';
import 'package:afritality/animations/FadeAnimations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneVerificationPage extends StatefulWidget {
  @override
  _PhoneVerificationPageState createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String _input = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          width: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Create account',
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: .5,
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: LayoutBuilder(
            builder:
                (BuildContext context, BoxConstraints viewportConstraints) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.end,
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          SizedBox(
                            height: 40,
                          ),
                          FadeAnimation(
                            0.6,
                            Container(
                              child: Center(
                                child: Image(
                                  height: MediaQuery.of(context).size.width / 4,
                                  //width: 300,
                                  fit: BoxFit.contain,
                                  image: AssetImage(
                                    'assets/images/otp_icon.png',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                            0.8,
                            Text(
                              'Enter your mobile \nnumber to create account',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black87,
                                  letterSpacing: .5,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            1.0,
                            Text(
                              'We will send you one time verification password',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black87,
                                  letterSpacing: .5,
                                ),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          FadeAnimation(
                            1.2,
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: 180,
                              ),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 16,
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black87,
                                    //letterSpacing: .5,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  labelText: 'Phone',
                                  labelStyle: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontSize: 18.0,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  errorStyle: TextStyle(
                                    color: Colors.brown,
                                  ),
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    _input = val.trim();
                                  });
                                },
                                validator: (val) =>
                                    (val[0] == '+' && val.length < 6)
                                        ? 'Enter a valid number'
                                        : null,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          FadeAnimation(
                            1.4,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: ButtonTheme(
                                minWidth: double.infinity,
                                height: 48.0,
                                child: FlatButton(
                                  color: Color(0xff4da328),
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState.validate()) {
                                      reFormatPhone();
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'Enter a valid number!',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                  child: Text(
                                    'Send',
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        //fontWeight: FontWeight.bold,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(4.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  reFormatPhone() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => CompleteVerificationPage(
          phone: _input,
        ),
      ),
    );
  }
}
