import 'package:afritality/animations/FadeAnimations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class OurGalleryPage extends StatefulWidget {
  final String userId;
  OurGalleryPage({this.userId});

  @override
  _OurGalleryPageState createState() => _OurGalleryPageState(userId: userId);
}

class _OurGalleryPageState extends State<OurGalleryPage> {
  String userId;
  _OurGalleryPageState({this.userId});

  PageController _pageController;
  int totalPage = 4;

  void _onScroll() {}

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    )..addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Gallery')
            .orderBy('added_time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: SpinKitPulse(
                  color: Colors.blue,
                  size: 100.0,
                ),
              ),
            );
          } else {
            if (snapshot.data.documents.length == 0) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Image(
                    image: AssetImage('assets/images/empty.png'),
                    width: double.infinity,
                  ),
                ),
              );
            } else {
              return PageView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot item = snapshot.data.documents[index];
                  return galleryItem(
                      index, item, snapshot.data.documents.length);
                },
              );
            }
          }
        },
      ),
    );
  }

  Widget galleryItem(int index, DocumentSnapshot item, int count) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(item['image_url']), fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight, stops: [
          0.3,
          0.9
        ], colors: [
          Colors.black.withOpacity(.6),
          Colors.black.withOpacity(.0),
        ])),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    FadeAnimation(
                      0,
                      Text(
                        (index + 1).toString(),
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '/' + count.toString(),
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: .5,
                        ),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeAnimation(
                        1.5,
                        Row(
                          children: [
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 3),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white54,
                                    size: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'James kalunga',
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 3),
                                  child: Icon(
                                    Icons.access_time,
                                    color: Colors.white54,
                                    size: 12,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  item['happened_time'],
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                      letterSpacing: .5,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeAnimation(
                          1.5,
                          Text(
                            item['image_caption'],
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                letterSpacing: .5,
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
