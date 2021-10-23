import 'package:afritality/AdminPages/AddDayPicturePage.dart';
import 'package:afritality/AdminPages/AddInAppNotificationPage.dart';
import 'package:afritality/AdminPages/AddToGalleryPage.dart';
import 'package:afritality/Widgets/ActionCorneredButton.dart';
import 'package:afritality/Widgets/actionBox.dart';
import 'package:afritality/routes/ScaleRoute.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AddItemsPage extends StatefulWidget {
  final String userId;
  AddItemsPage({this.userId});

  @override
  _AddItemsPageState createState() => _AddItemsPageState(userId: userId);
}

class _AddItemsPageState extends State<AddItemsPage> {
  String userId;
  _AddItemsPageState({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4da328),
        title: Text(
          'Add items',
          style: GoogleFonts.ptSans(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                        builder: (_) => AddDayPicturePage(
                          userId: userId,
                        ),
                      ),
                    );
                  },
                  child: actionBox(
                    'Add \npicture of the day',
                    Icons.add,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => AddToGalleryPage(
                          userId: userId,
                        ),
                      ),
                    );
                  },
                  child: actionBox(
                    'Add \nto gallery',
                    Icons.add,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      ScaleRoute(
                        page: AddInAppNotificationPage(),
                      ),
                    );
                  },
                  child: actionCorneredButton(
                      "Display \na notification",
                      'https://img.icons8.com/color/48/000000/event-accepted-tentatively.png',
                      'assets/images/lion.jpg'),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      ScaleRoute(
                        page: AddDayPicturePage(),
                      ),
                    );
                  },
                  child: actionCorneredButton(
                    "Add \na quote",
                    'https://img.icons8.com/clouds/100/000000/microphone.png',
                    'assets/images/bananas.jpg',
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      ScaleRoute(
                        page: AddDayPicturePage(),
                      ),
                    );
                  },
                  child: actionCorneredButton(
                    "Caută \nun subiect",
                    'https://img.icons8.com/bubbles/50/000000/speaker.png',
                    'assets/images/trees.jpg',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
