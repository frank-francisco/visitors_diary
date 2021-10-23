import 'package:afritality/UserPages/SwahiliAdvancedPage.dart';
import 'package:afritality/UserPages/SwahiliBeginnerPage.dart';
import 'package:afritality/UserPages/SwahiliIntermediatePage.dart';
import 'package:afritality/Widgets/actionLevel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LearnSwahiliPage extends StatefulWidget {
  final String userId;
  LearnSwahiliPage({this.userId});

  @override
  _LearnSwahiliPageState createState() =>
      _LearnSwahiliPageState(userId: userId);
}

class _LearnSwahiliPageState extends State<LearnSwahiliPage> {
  String userId;
  _LearnSwahiliPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4da328),
        title: Text(
          'Learn Swahili',
          style: GoogleFonts.openSans(),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('user_id', isEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SpinKitThreeBounce(
                  color: Colors.grey,
                  size: 20.0,
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
                return pageUi(snapshot.data.documents[0]);
              }
            }
          },
        ),
      ),
    );
  }

  Widget pageUi(DocumentSnapshot myInfo) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 55,
                  backgroundColor: Color(0xffFDCF09),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(myInfo['user_image']),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          '327',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontSize: 16.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        Text(
                          'Scores',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        Text(
                          'Total performance 7/10',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => SwahiliBeginnerPage(
                      userId: userId,
                    ),
                  ),
                );
              },
              child: actionLevel(
                'BEGINNER',
                'Score 7/312',
                FontAwesomeIcons.baby,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => SwahiliIntermediatePage(
                      userId: userId,
                    ),
                  ),
                );
              },
              child: actionLevel(
                'INTERMEDIATE',
                'Score 7/312',
                FontAwesomeIcons.walking,
              ),
            ),
            SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => SwahiliAdvancedPage(
                      userId: userId,
                    ),
                  ),
                );
              },
              child: actionLevel(
                'ADVANCED',
                'Score 7/312',
                FontAwesomeIcons.running,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
