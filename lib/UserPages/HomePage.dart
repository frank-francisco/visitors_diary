import 'package:afritality/AdminPages/AddDayPicturePage.dart';
import 'package:afritality/AdminPages/AddItemsPage.dart';
import 'package:afritality/Services/ImageOfDay.dart';
import 'package:afritality/Services/ProfileServices.dart';
import 'package:afritality/UserPages/GettingStartedScreen.dart';
import 'package:afritality/UserPages/LearnSwahiliPage.dart';
import 'package:afritality/UserPages/NotificationEngagePage.dart';
import 'package:afritality/UserPages/OurGalleryPage.dart';
import 'package:afritality/UserPages/SupportUsPage.dart';
import 'package:afritality/UserPages/TheFamilyPage.dart';
import 'package:afritality/Widgets/actionBox.dart';
import 'package:afritality/animations/FadeAnimations.dart';
import 'package:afritality/routes/ScaleRoute.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String onlineUserId;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  bool userFlag = false;
  bool imageFlag = false;
  var details;
  var imageInfo;
  String onlineUserId = '';

  DateTime d = Jiffy(DateTime.now()).subtract(years: 1);

  @override
  void initState() {
    super.initState();
    manageUser();
    getImage();
  }

  manageUser() {
    final User user = _auth.currentUser;
    setState(() {
      onlineUserId = user.uid;
    });
    if (user != null) {
      ProfileService().getProfileInfo(user.uid).then((QuerySnapshot docs) {
        if (docs.docs.isNotEmpty) {
          setState(
            () {
              userFlag = true;
              details = docs.docs[0].data();
            },
          );
        }
      });
    } else {}
  }

  getImage() {
    ImageOfDay()
        .getImageInfo((DateFormat('dd_MM_yyyy').format(d)).toString())
        .then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        setState(
          () {
            imageFlag = true;
            imageInfo = docs.docs[0].data();
          },
        );
      }
    });
  }

  Widget normalPopupMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        size: 30.0,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: '0',
          child: Text('Log out'),
        ),
      ],
      onSelected: (retVal) {
        if (retVal == '0') {
          _logOut();
        }
      },
    );
  }

  Future _logOut() async {
    try {
      await FirebaseAuth.instance.signOut();

      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (context) => GettingStartedScreen(),
          ),
          (r) => false);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton:
          userFlag == true && details['account_type'] != 'Admin'
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => AddItemsPage(
                          userId: onlineUserId,
                        ),
                      ),
                    );
                  },
                )
              : null,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: <Widget>[
              normalPopupMenuButton(),
            ],
            centerTitle: true,
            expandedHeight: MediaQuery.of(context).size.width * 2 / 3,
            backgroundColor: Theme.of(context).primaryColor,
            pinned: true,
            floating: false,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  centerTitle: true,
                  title: AnimatedOpacity(
                    duration: Duration(milliseconds: 300),
                    opacity: constraints.biggest.height < 120.0 ? 1.0 : 0.0,
                    child: Text('Afritality'),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageFlag
                            ? NetworkImage(imageInfo['image_url'])
                            : NetworkImage(
                                'https://picsum.photos/200/300/?blur'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [Colors.black, Colors.black.withOpacity(.2)],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FadeAnimation(
                              1,
                              Text(
                                'Today last year',
                                style: GoogleFonts.ptSans(
                                  textStyle: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white60,
                                    letterSpacing: .5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FadeAnimation(
                                  1.3,
                                  Text(
                                    imageFlag
                                        ? imageInfo['formatted_time']
                                        : 'No image to show',
                                    style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white70,
                                        letterSpacing: .5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(16),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  crossAxisCount: 2,
                  childAspectRatio: (2 / 1.3),
                  shrinkWrap: true,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => LearnSwahiliPage(
                              userId: onlineUserId,
                            ),
                          ),
                        );
                      },
                      child: actionBox(
                        'Learn swahili',
                        FontAwesomeIcons.signLanguage,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => OurGalleryPage(
                              userId: onlineUserId,
                            ),
                          ),
                        );
                      },
                      child: actionBox(
                        'Our gallery',
                        FontAwesomeIcons.images,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => TheFamilyPage(
                              userId: onlineUserId,
                            ),
                          ),
                        );
                      },
                      child: actionBox(
                        'The family',
                        FontAwesomeIcons.users,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => SupportUsPage(
                              userId: onlineUserId,
                            ),
                          ),
                        );
                      },
                      child: actionBox(
                        'Support us',
                        FontAwesomeIcons.shoppingBag,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Categories')
                      .orderBy('added_time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        child: Center(
                          child: SpinKitThreeBounce(
                            color: Colors.black54,
                            size: 20.0,
                          ),
                        ),
                      );
                    } else {
                      if (snapshot.data.documents.length == 0) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 800,
                            ),
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Image(
                                  image: AssetImage('assets/images/empty.png'),
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Visibility(
                              visible: true,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('In_App_Notification')
                                    .orderBy('notification_time',
                                        descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                    //_emptyCard();
                                  } else {
                                    if (snapshot.data.documents.length == 0) {
                                      return Container();
                                      //_emptyCard();
                                    } else {
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            snapshot.data.documents.length,
                                        itemBuilder: (context, index) {
                                          DocumentSnapshot myNotifications =
                                              snapshot.data.documents[0];
                                          return _notificationItem(
                                              index, myNotifications);
                                        },
                                      );
                                    }
                                  }
                                },
                              ),
                            ),
                            GridView.count(
                              primary: false,
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              padding: EdgeInsets.all(10),
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              children: List.generate(
                                  snapshot.data.documents.length, (index) {
                                DocumentSnapshot myCategories =
                                    snapshot.data.documents[index];
                                return _categoryItem(index, myCategories);
                              }),
                            ),
                            SizedBox(
                              height: 900,
                            ),
                          ],
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _categoryItem(
    int index,
    DocumentSnapshot myCategories,
  ) {
    return GestureDetector(
      onLongPress: () {
        // Navigator.push(
        //   context,
        //   ScaleRoute(
        //     page: MemberEditPage(
        //       memberId: myPussies['user_id'],
        //       memberName: myPussies['user_name'],
        //       memberDescription: myPussies['about_user'],
        //       memberImage: myPussies['user_image'],
        //     ),
        //   ),
        // );
      },
      onTap: () {
        // Navigator.push(
        //   context,
        //   ScaleRoute(
        //     page: MemberEngagePage(
        //       memberId: myPussies['user_id'],
        //       memberName: myPussies['user_name'],
        //     ),
        //   ),
        // );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 2,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: CachedNetworkImage(
                  imageUrl: myCategories['category_image'],
                  imageBuilder: (context, imageProvider) => Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => Image(
                    width: double.infinity,
                    image: AssetImage('assets/images/place_holder.png'),
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image(
                    width: double.infinity,
                    image: AssetImage('assets/images/place_holder.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                myCategories['category_name'],
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                myCategories['about_category'],
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyCard() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
      ),
      child: Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.error_outline),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "This is the title",
                    style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "Just some text to attract our users attention to click on some stuff",
                    style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        letterSpacing: .5,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'BUY TICKETS',
                          style: GoogleFonts.ptSans(
                            textStyle: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff003e7f),
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        child: const Text('LISTEN'),
                        onPressed: () {/* ... */},
                      ),
                      // const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationItem(int index, DocumentSnapshot myNotifications) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        top: 10.0,
      ),
      child: Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.error_outline),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    myNotifications['notification_title'],
                    style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    myNotifications['notification_summary'],
                    style: GoogleFonts.ptSans(
                      textStyle: TextStyle(
                        fontSize: 18.0,
                        letterSpacing: .5,
                      ),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Text(
                          'BUY TICKETS',
                          style: GoogleFonts.ptSans(
                            textStyle: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff003e7f),
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        onPressed: () {/* ... */},
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        child: const Text('READ MORE'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            ScaleRoute(
                              page: NotificationEngagePage(
                                postId: myNotifications['notification_id'],
                              ),
                            ),
                          );
                        },
                      ),
                      // const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
