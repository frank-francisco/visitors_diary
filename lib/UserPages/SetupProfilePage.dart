import 'dart:async';
import 'dart:io';
import 'package:afritality/UserPages/HomePage.dart';
import 'package:afritality/routes/ScaleRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class SetupProfilePage extends StatefulWidget {
  @override
  _SetupProfilePageState createState() => _SetupProfilePageState();
}

class _SetupProfilePageState extends State<SetupProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  TextEditingController _nameController;
  TextEditingController _bioController;

  String name = '';
  String image = '';
  String bio = '';
  String onlineUserId;
  String onlineUserEmail;
  String _uploadedFileURL;
  bool _loading = false;
  bool _absorb = false;

  File _imageFile;
  getImageFile(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxHeight: 1000,
        maxWidth: 1000,
        compressQuality: 80,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop your image',
            toolbarColor: Colors.blue,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _imageFile = croppedFile;
      print(_imageFile.lengthSync());
    });
  }

  @override
  void initState() {
    super.initState();

    getUser().then((user) async {
      if (user != null) {
        setState(() {
          onlineUserId = user.uid;
          onlineUserEmail = user.email;
          name = user.displayName;
          image = user.photoURL;
          bio =
              'Hello there! \nMy name is $name. I am using Afritality App to get the latest update about the Afritality family.';
          _nameController = new TextEditingController(text: name);
          _bioController = new TextEditingController(text: bio);
        });
      }
    });
    _refreshViews();
  }

  Future<User> getUser() async {
    return _auth.currentUser;
  }

  _refreshViews() {
    Timer(
      Duration(seconds: 2),
      () {
        _formKey.currentState.validate();
      },
    );
  }

  //create data with google image
  _saveWithOldImage() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(onlineUserId);
    Map<String, dynamic> tasks = {
      'user_name': name,
      'account_type': 'Normal',
      'email_verification': 'Verified',
      'user_authority': 'null',
      'user_email': onlineUserEmail,
      'user_id': onlineUserId,
      'user_image': image,
      'user_phone': '',
      'user_city': '',
      'user_plan': 'null',
      'user_power': 'null',
      'registration_number': '',
      'user_locality': '',
      'about_user': bio,
      'user_verification': 'null',
      'action_title': '',
      'user_extra': 'extra',
      'notification_count': 0,
      'device_token': 'not set',
    };
    ds.set(tasks).whenComplete(
      () {
        setState(() {
          _loading = false;
          Navigator.of(context).pushAndRemoveUntil(
              ScaleRoute(
                page: HomePage(),
              ),
              (Route<dynamic> route) => false);
        });
      },
    );
  }

  //create data with picked image
  _saveWithNewImage() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Users').doc(onlineUserId);
    Map<String, dynamic> tasks = {
      'user_name': name,
      'account_type': 'Normal',
      'email_verification': 'Verified',
      'user_authority': 'null',
      'user_email': onlineUserEmail,
      'user_id': onlineUserId,
      'user_image': _uploadedFileURL,
      'user_phone': '',
      'user_city': '',
      'user_plan': 'null',
      'user_power': 'null',
      'registration_number': '',
      'user_locality': '',
      'about_user': bio,
      'user_verification': 'null',
      'action_title': '',
      'user_extra': 'extra',
      'notification_count': 0,
      'device_token': 'not set',
    };
    ds.set(tasks).whenComplete(
      () {
        setState(() {
          _loading = false;
          Navigator.of(context).pushAndRemoveUntil(
              ScaleRoute(
                page: HomePage(),
              ),
              (Route<dynamic> route) => false);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image(
            image: AssetImage(
              'assets/images/2.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: AbsorbPointer(
            absorbing: _absorb,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            //Navigator.of(context).pop();
                            SystemNavigator.pop();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.black26,
                            radius: 16,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  LayoutBuilder(
                    builder: (BuildContext context,
                        BoxConstraints viewportConstraints) {
                      return Container(
                        //color: Colors.white,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.always,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      child: InkWell(
                                        child: _imageFile == null
                                            ? image.isEmpty
                                                ? CircleAvatar(
                                                    radius: 85,
                                                    backgroundColor:
                                                        Colors.white54,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      radius: 80,
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    radius: 85,
                                                    backgroundColor:
                                                        Colors.white54,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.green,
                                                      backgroundImage:
                                                          NetworkImage(image),
                                                      radius: 80,
                                                    ),
                                                  )
                                            : CircleAvatar(
                                                radius: 85,
                                                backgroundColor: Colors.white54,
                                                child: CircleAvatar(
                                                  backgroundColor: Colors.blue,
                                                  backgroundImage:
                                                      FileImage(_imageFile),
                                                  foregroundColor: Colors.white,
                                                  radius: 80,
                                                  //child: Text('Select Image'),
                                                ),
                                              ),
                                        onTap: () {
                                          getImageFile(ImageSource.gallery);
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                  Text(
                                    'Join the \nAfritality family',
                                    style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                        fontSize: 28.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: _nameController,
                                    textCapitalization:
                                        TextCapitalization.words,
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
                                      labelStyle: GoogleFonts.ptSans(
                                        textStyle: TextStyle(
                                          letterSpacing: .5,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.teal),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(4.0),
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.all(15.0),
                                      errorStyle:
                                          TextStyle(color: Colors.brown),
                                    ),
                                    onChanged: (val) {
                                      setState(() => name = val);
                                    },
                                    validator: (val) =>
                                        val.isEmpty ? 'Enter a name' : null,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: _bioController,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    maxLength: 150,
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
                                      labelStyle: GoogleFonts.ptSans(
                                        textStyle: TextStyle(
                                          letterSpacing: .5,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.teal),
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(4.0),
                                        ),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.all(15.0),
                                      errorStyle:
                                          TextStyle(color: Colors.brown),
                                    ),
                                    onChanged: (val) {
                                      setState(() => bio = val);
                                    },
                                    validator: (val) => val.length < 50
                                        ? 'Bio must be longer that 50 chars'
                                        : null,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  _loading
                                      ? Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.blue[200],
                                              borderRadius:
                                                  new BorderRadius.all(
                                                      Radius.circular(24.0))),
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
                                            color: Colors.lightGreen,
                                            child: Text(
                                              'Continue',
                                              style: GoogleFonts.ptSans(
                                                textStyle: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white,
                                                  //fontWeight: FontWeight.bold,
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
                                                  BorderRadius.circular(24),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            textColor: Colors.white,
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                if (_imageFile == null) {
                                                  _saveWithOldImage();
                                                  setState(() {
                                                    _loading = true;
                                                    _absorb = true;
                                                  });
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
        ),
      ],
    );
  }

  Future<void> _startUploading() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('Profiles/$onlineUserId').putFile(_imageFile);
      print('File Uploaded');

      String downloadURL =
          await storage.ref('Profiles/$onlineUserId').getDownloadURL();

      setState(() {
        _uploadedFileURL = downloadURL;
        _saveWithNewImage();
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
