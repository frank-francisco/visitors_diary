import 'package:afritality/Services/NotificationDetailsService.dart';
import 'package:afritality/Services/ProfileServices.dart';
import 'package:afritality/animations/FadeAnimations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';

class NotificationEngagePage extends StatefulWidget {
  final String postId;
  NotificationEngagePage({this.postId});
  @override
  _NotificationEngagePageState createState() =>
      _NotificationEngagePageState(postId: postId);
}

class _NotificationEngagePageState extends State<NotificationEngagePage> {
  String postId;
  _NotificationEngagePageState({this.postId});

  final databaseReference = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _onlineUserId;
  var onlineDetails;
  bool userFlag = false;
  var postDetails;
  var top = 0.0;
  bool pressed = false;

  @override
  void initState() {
    super.initState();

    getUser().then(
      (user) async {
        if (user != null) {
          final User user = _firebaseAuth.currentUser;
          _onlineUserId = user.uid;

          ProfileService()
              .getProfileInfo(_onlineUserId)
              .then((QuerySnapshot docs) {
            if (docs.docs.isNotEmpty) {
              setState(
                () {
                  onlineDetails = docs.docs[0].data();
                },
              );
              getPostData();
            }
          });
        }
      },
    );
  }

  getPostData() {
    NotificationDetailsService()
        .getNotificationInfo(postId)
        .then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        setState(() {
          userFlag = true;
          postDetails = docs.docs[0].data();
        });
      }
    });
  }

  Future<User> getUser() async {
    return _firebaseAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedCrossFade(
        firstChild: CustomScrollView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          slivers: <Widget>[
            SliverAppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              expandedHeight: MediaQuery.of(context).size.width * 2 / 3,
              backgroundColor: Colors.blue,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Container(height: 1200.0, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
        secondChild: userFlag
            ? Stack(
                children: <Widget>[
                  CustomScrollView(
                    slivers: <Widget>[
                      SliverAppBar(
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        centerTitle: true,
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              Share.share(
                                'https://2value.ro/read/news/${postDetails['news_id']}',
                                subject: 'Shared News',
                              );
                              // Share.share(
                              //   'https://2value.ro/read/news/${postDetails['news_id'].replaceAll(RegExp(' +'), '_')}',
                              //   subject: 'Shared News',
                              // );
                            },
                          ),
                        ],
                        expandedHeight:
                            MediaQuery.of(context).size.width * 2 / 3,
                        backgroundColor: Theme.of(context).primaryColor,
                        pinned: true,
                        floating: false,
                        flexibleSpace: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            top = constraints.biggest.height;
                            return FlexibleSpaceBar(
                              title: AnimatedOpacity(
                                  duration: Duration(milliseconds: 300),
                                  opacity: top < 120.0 ? 1.0 : 0.0,
                                  child: Container() //displayUserInfo(),
                                  ),
                              centerTitle: true,
                              collapseMode: CollapseMode.pin,
                              background: CachedNetworkImage(
                                placeholder: (context, url) => Image(
                                    image: AssetImage(
                                        'assets/images/loading.jpg')),
                                imageUrl:
                                    '${postDetails['notification_image']}',
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 20, 40),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  FadeAnimation(
                                    1,
                                    Row(
                                      children: [
                                        Container(
                                          height: 30.0,
                                          //width: 100,
                                          color: Colors.transparent,
                                          child: new Container(
                                            decoration: new BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.all(
                                                const Radius.circular(15.0),
                                              ),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 32,
                                                ),
                                                child: Text(
                                                  postDetails[
                                                      'notification_category'],
                                                  style: GoogleFonts.ptSans(
                                                    fontSize: 14,
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: .5,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              pressed = !pressed;
                                            });
                                          },
                                          child: pressed == true
                                              ? Icon(
                                                  CupertinoIcons.heart_solid,
                                                  color: Colors.black54,
                                                  size: 30,
                                                )
                                              : Icon(
                                                  CupertinoIcons.heart,
                                                  color: Colors.black54,
                                                  size: 30,
                                                ),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Icon(
                                          CupertinoIcons.bookmark,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  FadeAnimation(
                                    1.1,
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.clock,
                                          color: Colors.grey,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        Text(
                                          postDetails['formatted_time'],
                                          style: GoogleFonts.ptSans(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  FadeAnimation(
                                    1,
                                    Text(
                                      postDetails['notification_title'],
                                      style: GoogleFonts.ptSans(
                                        fontSize: 18,
                                        height: 1.4,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  FadeAnimation(
                                    1.1,
                                    Container(
                                      color: Colors.blue,
                                      width: 100,
                                      height: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  FadeAnimation(
                                    1.2,
                                    Text(
                                      postDetails['notification_body'],
                                      style: GoogleFonts.ptSans(
                                        fontSize: 16,
                                        height: 1.4,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              )
            : Container(),
        crossFadeState:
            userFlag ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 400),
      ),
    );
  }
}
