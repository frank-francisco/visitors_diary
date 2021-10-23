import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationDetailsService {
  getNotificationInfo(String postId) {
    return FirebaseFirestore.instance
        .collection('In_App_Notification')
        .where('notification_id', isEqualTo: postId)
        .get();
  }
}
