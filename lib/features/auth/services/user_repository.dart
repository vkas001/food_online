import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore data-boundary for user profiles.
///
/// Ported from `service/data_base.dart`.
class UserRepository {
  Future<void> addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }
}