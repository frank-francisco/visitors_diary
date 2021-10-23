import 'dart:io';
import 'package:afritality/UserPages/HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class AccountSetupPage extends StatefulWidget {
  @override
  _AccountSetupPageState createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends State<AccountSetupPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  String name = '';
  String bio = '';
  String onlineUserId;
  String phone;
  String _uploadedFileURL;
  bool _loading = false;
  bool _absorb = false;

  File _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxHeight: 1000,
        maxWidth: 1000,
        compressQuality: 80,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _imageFile = croppedFile;
    });
  }

  @override
  void initState() {
    super.initState();
    getUid();
  }

  void getUid() {
    final User user = _auth.currentUser;
    setState(() {
      onlineUserId = user.uid;
      phone = user.phoneNumber;
    });
  }

  //create data with picked image
  _saveUser() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(onlineUserId);
    Map<String, dynamic> tasks = {
      'user_name': name,
      'account_type': 'Normal',
      'email_verification': 'Unverified',
      'user_authority': '-',
      'user_email': '-',
      'user_id': onlineUserId,
      'user_image': _uploadedFileURL,
      'user_phone': phone,
      'user_country': '-',
      'user_plan': '-',
      'user_locality': '-',
      'about_user': bio,
      'user_verification': '-',
      'action_title': '',
      'account_creation_time': DateTime.now().millisecondsSinceEpoch,
      'control_number': '-',
      'user_extra': 'extra',
      'notification_count': 1,
      'device_token': '-',
    };
    ds.set(tasks).whenComplete(
      () {
        sendNotification();
      },
    );
  }

  sendNotification() {
    DocumentReference ds = _fireStore
        .collection('Notifications')
        .doc('important')
        .collection(onlineUserId)
        .doc();
    Map<String, dynamic> tasks = {
      'notification_tittle': 'Welcome to Afritality',
      'notification_details':
          'We are glad you joined the Afritality family, welcome to the home of African hospitality.',
      'notification_time': DateTime.now().millisecondsSinceEpoch,
      'notification_sender': 'Afritality',
      'action_title': '',
      'action_destination': '',
      'action_key': '',
      'post_id': 'extra',
    };
    ds.set(tasks).whenComplete(
      () {
        setState(
          () {
            _loading = false;
            Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => HomePage(),
                ),
                (r) => false);
          },
        );
        print('Account created and notification sent.');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            SystemNavigator.pop();
          },
        ),
      ),
      body: AbsorbPointer(
        absorbing: _absorb,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              LayoutBuilder(
                builder:
                    (BuildContext context, BoxConstraints viewportConstraints) {
                  return Container(
                    //color: Colors.white,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.always,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Center(
                                child: Container(
                                  child: GestureDetector(
                                    child: _imageFile == null
                                        ? CircleAvatar(
                                            radius: 73,
                                            backgroundColor: Colors.black12,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                'assets/images/profile_holder.png',
                                              ),
                                              radius: 70,
                                            ),
                                          )
                                        : CircleAvatar(
                                            radius: 73,
                                            backgroundColor: Colors.grey,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.blue,
                                              backgroundImage:
                                                  FileImage(_imageFile),
                                              foregroundColor: Colors.white,
                                              radius: 70,
                                              //child: Text('Select Image'),
                                            ),
                                          ),
                                    onTap: () {
                                      getImage();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                'Join \nAfritality family',
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                maxLength: 30,
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.black,
                                    letterSpacing: .5,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white38,
                                  labelText: 'Name',
                                  labelStyle: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(0.0),
                                  errorStyle: TextStyle(color: Colors.brown),
                                ),
                                onChanged: (val) {
                                  setState(() => name = val);
                                },
                                validator: (val) =>
                                    val.isEmpty ? 'Enter a name' : null,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLength: 300,
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.black,
                                    letterSpacing: .5,
                                  ),
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white38,
                                  labelText: 'Bio',
                                  labelStyle: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      letterSpacing: .5,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.all(0.0),
                                  errorStyle: TextStyle(color: Colors.brown),
                                ),
                                onChanged: (val) {
                                  setState(() => bio = val);
                                },
                                validator: (val) =>
                                    val.length < 50 ? 'Too short' : null,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              _loading
                                  ? Container(
                                      decoration: new BoxDecoration(
                                        color: Color(0xff4da328),
                                        borderRadius: new BorderRadius.all(
                                          Radius.circular(4.0),
                                        ),
                                      ),
                                      width: double.infinity,
                                      height: 48.0,
                                      child: Center(
                                        child: SpinKitThreeBounce(
                                          color: Colors.white,
                                          size: 20.0,
                                        ),
                                      ),
                                    )
                                  : ButtonTheme(
                                      height: 48,
                                      child: FlatButton(
                                        color: Color(0xff4da328),
                                        child: Text(
                                          'Continue',
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white,
                                              letterSpacing: .5,
                                            ),
                                          ),
                                        ),
                                        shape: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.white38,
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        textColor: Colors.white,
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            if (_imageFile == null) {
                                              final snackBar = SnackBar(
                                                content: Text(
                                                  'Select image!',
                                                  textAlign: TextAlign.center,
                                                ),
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(snackBar);
                                            } else {
                                              _startUploading();
                                              setState(() {
                                                _loading = true;
                                                _absorb = true;
                                              });
                                            }
                                          } else {
                                            final snackBar = SnackBar(
                                              content: Text(
                                                'Please fill everything!',
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                      ),
                                    ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startUploading() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('Profiles/$onlineUserId.jpg').putFile(_imageFile);
      print('File Uploaded');

      String downloadURL =
          await storage.ref('Profiles/$onlineUserId.jpg').getDownloadURL();

      setState(() {
        _uploadedFileURL = downloadURL;
        _saveUser();
      });
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
