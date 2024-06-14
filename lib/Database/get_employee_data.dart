import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  static Future<Map<String, dynamic>> fetchUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userData.exists) {
          return userData.data() as Map<String, dynamic>;
        } else {
          throw Exception("Document does not exist");
        }
      } else {
        throw Exception("No current user");
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return {};
    }
  }
}
