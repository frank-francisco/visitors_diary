import 'dart:async';
import 'package:afritality/UserPages/Wrapper.dart';
import 'package:afritality/animations/FadeAnimations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CompleteVerificationPage extends StatefulWidget {
  final String phone;
  CompleteVerificationPage({this.phone});

  @override
  _CompleteVerificationPageState createState() =>
      _CompleteVerificationPageState(phone: phone);
}

class _CompleteVerificationPageState extends State<CompleteVerificationPage> {
  String phone;
  _CompleteVerificationPageState({this.phone});

  var onTapRecognizer;
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType> errorController;

  FirebaseAuth auth = FirebaseAuth.instance;
  bool hasError = false;
  String currentText = "";
  String _verificationId = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  //Timer
  Timer _timer;
  int _start = 0;
  int _icon = 0;
  bool resendingCode = false;
  bool resendInAction = false;

  @override
  void initState() {
    super.initState();
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };
    errorController = StreamController<ErrorAnimationType>();
    verifyPhone();
  }

  @override
  void dispose() {
    _timer?.cancel();
    errorController.close();
    //textEditingController.dispose();
    super.dispose();
  }

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
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: Text(
              'Verify account',
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
                            0.8,
                            Text(
                              'Enter verification \ncode to verify phone number',
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
                              resendingCode
                                  ? ('We are sending the verification code to the phone number "$phone".')
                                  : ('We have sent the verification code to the phone number "$phone", it might take a moment to arrive.'),
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
                            Form(
                              key: formKey,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 30),
                                  child: PinCodeTextField(
                                    appContext: context,
                                    pastedTextStyle: TextStyle(
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    length: 6,
                                    obscureText: false,
                                    obscuringCharacter: '*',
                                    blinkWhenObscuring: true,
                                    animationType: AnimationType.fade,
                                    validator: (v) {
                                      if (v.length < 6) {
                                        return "Too short";
                                      } else {
                                        return null;
                                      }
                                    },
                                    pinTheme: PinTheme(
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      fieldHeight: 50,
                                      fieldWidth: 40,
                                      activeFillColor: hasError
                                          ? Colors.orange
                                          : Colors.white,
                                    ),
                                    cursorColor: Colors.black,
                                    animationDuration:
                                        Duration(milliseconds: 300),
                                    //backgroundColor: Colors.blue.shade50,
                                    enableActiveFill: true,
                                    errorAnimationController: errorController,
                                    controller: textEditingController,
                                    keyboardType: TextInputType.number,
                                    boxShadows: [
                                      BoxShadow(
                                        offset: Offset(0, 1),
                                        color: Colors.black12,
                                        blurRadius: 10,
                                      )
                                    ],
                                    onCompleted: (v) {
                                      print("Completed");
                                      _signInWithPhoneNumber(currentText);
                                    },
                                    // onTap: () {
                                    //   print("Pressed");
                                    // },
                                    onChanged: (value) {
                                      print(value);
                                      setState(() {
                                        currentText = value;
                                      });
                                    },
                                    beforeTextPaste: (text) {
                                      print("Allowing to paste $text");
                                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                      return true;
                                    },
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                            1.4,
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                color: Colors.grey[200],
                                width: double.infinity,
                                padding: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          _icon == 0
                                              ? Icon(
                                                  Icons.error_outline,
                                                  size: 24,
                                                  color: Colors.black38,
                                                )
                                              : SpinKitPulse(
                                                  color: Colors.black38,
                                                  size: 24.0,
                                                ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                children: [
                                                  resendingCode
                                                      ? Expanded(
                                                          child: Text(
                                                            'Sending...',
                                                            style: GoogleFonts
                                                                .openSans(
                                                              textStyle:
                                                                  TextStyle(
                                                                fontSize: 14.0,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Expanded(
                                                          child: _start > 0
                                                              ? Text(
                                                                  'If you have not received the confirmation code, you can resend it in $_start seconds.',
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    textStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Text(
                                                                  'If you have not received the confirmation code, you can resend again.',
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    textStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                    ),
                                                                  ),
                                                                ),
                                                        ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          TextButton(
                                            child: Text(
                                              'Resend',
                                            ),
                                            onPressed: resendInAction
                                                ? null
                                                : () {
                                                    verifyPhone();
                                                  },
                                          ),
                                          // const SizedBox(width: 8),
                                        ],
                                      ),
                                    ],
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

  verifyPhone() async {
    setState(() {
      resendingCode = true;
      resendInAction = true;
      _icon = 1;
    });
    await auth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 120),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        if (auth.currentUser != null) {
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => Wrapper(),
              ),
              (r) => false);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.code);

        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
          _showInvalidPhoneDialog();
        } else if (e.code == 'invalid-verification-code') {
          errorController.add(
              ErrorAnimationType.shake); // Triggering error shake animation
          setState(() {
            hasError = true;
          });
        } else {
          print("Read: " + e.message);
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        // Create a PhoneAuthCredential with the code
        print('one here');
        startTimer();
        setState(() {
          this._verificationId = verificationId;
          resendingCode = false;
          _icon = 0;
        });
        if (currentText.length == 6) {
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
                  verificationId: verificationId, smsCode: currentText);

          // Sign the user in (or link) with the credential
          try {
            await auth.signInWithCredential(phoneAuthCredential);
            if (auth.currentUser != null) {
              Navigator.of(context).pushAndRemoveUntil(
                  CupertinoPageRoute(
                    builder: (context) => Wrapper(),
                  ),
                  (r) => false);
            }
          } catch (error) {
            if (error.code == 'invalid-verification-code') {
              errorController.add(
                  ErrorAnimationType.shake); // Triggering error shake animation
              setState(() {
                hasError = true;
              });
            }
            print(error.code);
          }
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this._verificationId = verificationId;
        });
      },
    );
  }

  void _signInWithPhoneNumber(String smsCode) async {
    PhoneAuthCredential _authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId, smsCode: smsCode);
    try {
      await auth.signInWithCredential(_authCredential);
      if (auth.currentUser != null) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => Wrapper(),
            ),
            (r) => false);
      }
    } catch (error) {
      if (error.code == 'invalid-verification-code') {
        errorController
            .add(ErrorAnimationType.shake); // Triggering error shake animation
        setState(() {
          hasError = true;
        });
      }
      print(error.code);
    }
  }

  void startTimer() {
    setState(() {
      _start = 120;
    });
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              resendInAction = false;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  _showInvalidPhoneDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)), //this right here
          child: Wrap(
            children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Invalid phone number!',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        'The phone number you have entered is invalid, please try again using a valid number.',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: 320.0,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Okay',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
