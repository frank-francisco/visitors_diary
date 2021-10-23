import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

actionBox(
  String txt,
  IconData iconInfo,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey[400]),
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.grey.withOpacity(0.4),
      //     spreadRadius: 2,
      //     blurRadius: 3,
      //     offset: Offset(0, 2), // changes position of shadow
      //   ),
      // ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.grey[400],
                    child: CircleAvatar(
                      radius: 17,
                      //backgroundColor: Color(0xffFDCF09),
                      backgroundColor: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          iconInfo,
                          color: Colors.black87,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(),
              ),
              Text(
                txt,
                textAlign: TextAlign.start,
                style: GoogleFonts.openSans(
                  fontSize: 14,
                  //fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
