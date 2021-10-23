import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddDayPicturePage extends StatefulWidget {
  final String userId;
  AddDayPicturePage({this.userId});

  @override
  _AddDayPicturePageState createState() =>
      _AddDayPicturePageState(userId: userId);
}

class _AddDayPicturePageState extends State<AddDayPicturePage> {
  String userId;
  _AddDayPicturePageState({this.userId});

  final _formKey = GlobalKey<FormState>();
  DateTime _date = DateTime.now();
  String shortDescription = '';
  File _imageFile;
  String _uploadedFileURL;
  bool _loading = false;

  getImageFile(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 3, ratioY: 2),
        maxHeight: 1080,
        maxWidth: 1920,
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
      print('Here:' + _imageFile.lengthSync().toString());
    });
  }

  createCategory() {
    DocumentReference ds = FirebaseFirestore.instance
        .collection('Gallery')
        .doc((DateFormat('dd_MM_yyyy').format(_date)).toString());
    Map<String, dynamic> tasks = {
      'image_url': _uploadedFileURL,
      'image_caption': shortDescription,
      'added_time': DateTime.now().millisecondsSinceEpoch,
      'formatted_time': DateFormat.yMMMd().format(_date),
      'likes_count': 0,
      'image_id': (DateFormat('dd_MM_yyyy').format(_date)).toString(),
    };
    ds.set(tasks).whenComplete(() {
      print('Category created');
      setState(() {
        _loading = false;
      });
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add picture'),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          color: Colors.black87,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            color: Colors.white,
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
                      SizedBox(
                        height: 20,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: Container(
                          child: InkWell(
                            child: _imageFile == null
                                ? Image(
                                    width: double.infinity,
                                    image: AssetImage(
                                      'assets/images/place_holder.png',
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : Image(
                                    width: double.infinity,
                                    image: FileImage(_imageFile),
                                    fit: BoxFit.cover),
                            onTap: () {
                              getImageFile(ImageSource.gallery);
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 300,
                        style: TextStyle(fontSize: 18.0, color: Colors.black54),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Mfafanua huyu mwanamke',
                          helperText: 'Maelezo mafupi juu ya huyu mwanamke.',
                          prefixIcon: Icon(
                            Icons.description,
                          ),
                          contentPadding: const EdgeInsets.all(15.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            ),
                          ),
                          errorStyle: TextStyle(color: Colors.brown),
                        ),
                        onChanged: (val) {
                          setState(() {
                            shortDescription = val.trim();
                          });
                        },
                        validator: (val) => val.length < 50
                            ? 'Maelezo mafupi sana, 50 chars min'
                            : null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _loading
                          ? Container(
                              decoration: new BoxDecoration(
                                  color: Colors.blue[200],
                                  borderRadius: new BorderRadius.all(
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
                                color: Colors.blueGrey,
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 2),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding: const EdgeInsets.all(8),
                                textColor: Colors.white,
                                onPressed: () async {
                                  if (_imageFile == null) {
                                    final snackBar = SnackBar(
                                      content: Text(
                                        'Select image!',
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  } else {
                                    if (_formKey.currentState.validate()) {
                                      setState(() => _loading = true);
                                      _startUploading();
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'Fill everything!',
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }
                                },
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _startUploading() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage
          .ref(
              'Gallery/${(DateFormat('dd_MM_yyyy').format(_date)).toString()}.jpg')
          .putFile(_imageFile);
      print('File Uploaded');

      String downloadURL = await storage
          .ref(
              'Gallery/${(DateFormat('dd_MM_yyyy').format(_date)).toString()}.jpg')
          .getDownloadURL();

      setState(() {
        _uploadedFileURL = downloadURL;
        createCategory();
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
