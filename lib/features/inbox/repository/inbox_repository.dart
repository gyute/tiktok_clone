import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createChatProvider = Provider((ref) => CreateChatRepository());

class CreateChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createChat(String myId, oppositeId) async {
    final docRef = await _firestore.collection("chat_rooms").add({
      "user1": myId,
      "user2": oppositeId,
    });

    return docRef.id;
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final users = await _firestore
        .collection("users")
        .where(Filter('email', isGreaterThanOrEqualTo: email))
        .get();

    return users.docs.firstOrNull?.data();
  }
}
