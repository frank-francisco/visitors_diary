import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

actionCorneredButton(
  String txt,
  String img,
  String bg,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      image: DecorationImage(
        image: AssetImage(bg),
        fit: BoxFit.cover,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          spreadRadius: 3,
          blurRadius: 4,
          offset: Offset(0, 1), // changes position of shadow
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(),
          ),
          Text(
            txt,
            textAlign: TextAlign.start,
            style: GoogleFonts.ptSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    ),
  );
}
