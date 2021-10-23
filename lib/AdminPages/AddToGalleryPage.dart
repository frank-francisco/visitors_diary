import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddToGalleryPage extends StatefulWidget {
  final String userId;
  AddToGalleryPage({this.userId});

  @override
  _AddToGalleryPageState createState() =>
      _AddToGalleryPageState(userId: userId);
}

class _AddToGalleryPageState extends State<AddToGalleryPage> {
  String userId;
  _AddToGalleryPageState({this.userId});

  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  DateTime _date = DateTime.now();
  String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  String caption = '';
  File _imageFile;
  String _uploadedFileURL;

  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: CropAspectRatio(ratioX: 9, ratioY: 16),
        maxHeight: 1920,
        maxWidth: 1080,
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
      print(_imageFile.lengthSync());
    });
  }

  _addToGallery() {
    DocumentReference ds =
        FirebaseFirestore.instance.collection('Gallery').doc();

    Map<String, dynamic> tasks = {
      'image_url': _uploadedFileURL,
      'image_caption': caption,
      'image_poster': userId,
      'added_time': DateTime.now().millisecondsSinceEpoch,
      'happened_time': DateFormat.yMMMd().format(_date),
      'image_id': '-',
    };
    ds.set(tasks).whenComplete(() {
      print('Tasks created');

      DocumentReference documentReferences =
          FirebaseFirestore.instance.collection('Gallery').doc(ds.id);
      Map<String, dynamic> _updateTasks = {
        'image_id': ds.id,
      };
      documentReferences.update(_updateTasks).whenComplete(() {
        Navigator.pop(context);
        setState(() {
          _loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff4da328),
        title: Text('Add to gallery'),
        centerTitle: true,
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
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        color: Colors.grey[200],
                        width: double.infinity,
                        padding: EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Icon(
                                      Icons.error_outline,
                                      size: 14,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Flexible(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'We would really appreciate if you can help to add image(s) that are relevant to Afritality in our gallery. Your name will be displayed below the image.',
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Center(
                      child: InkWell(
                        child: _imageFile == null
                            ? AspectRatio(
                                aspectRatio: (9 / 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: Container(
                                    width: double.infinity,
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/vertical_place_holder.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                            : AspectRatio(
                                aspectRatio: (9 / 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: Container(
                                    width: double.infinity,
                                    child: Image(
                                      image: FileImage(_imageFile),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                        onTap: () {
                          getImage();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 300,
                        style: TextStyle(fontSize: 18.0, color: Colors.black54),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          //hintText: 'Captions',
                          labelText: 'Caption',
                          contentPadding: const EdgeInsets.all(0.0),
                          errorStyle: TextStyle(color: Colors.brown),
                        ),
                        onChanged: (val) {
                          setState(() {
                            caption = val.trim();
                          });
                        },
                        validator: (val) =>
                            val.length < 50 ? 'Too short, 50 chars min' : null,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _loading
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
                          : SizedBox(
                              height: 48,
                              child: FlatButton(
                                color: Color(0xff4da328),
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                                shape: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xff4da328), width: 2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                textColor: Colors.white,
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
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
                                      _startUpload();
                                    } else {
                                      final snackBar = SnackBar(
                                        content: Text(
                                          'Enter caption!',
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
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _startUpload() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await storage.ref('Gallery/$fileName.jpg').putFile(_imageFile);
      print('File Uploaded');

      String downloadURL =
          await storage.ref('Gallery/$fileName.jpg').getDownloadURL();

      setState(() {
        _uploadedFileURL = downloadURL;
        _addToGallery();
      });
    } on FirebaseException catch (e) {
      final snackBar = SnackBar(
        content: Text(
          e.message,
          textAlign: TextAlign.center,
        ),
      );
      Scaffold.of(context).showSnackBar(snackBar);
      setState(() {
        _loading = false;
      });
    }
  }
}
