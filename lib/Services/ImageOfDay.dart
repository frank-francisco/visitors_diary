import 'package:cloud_firestore/cloud_firestore.dart';

class ImageOfDay {
  getImageInfo(String id) {
    return FirebaseFirestore.instance
        .collection('Gallery')
        .where('image_id', isEqualTo: id)
        .get();
  }
}
