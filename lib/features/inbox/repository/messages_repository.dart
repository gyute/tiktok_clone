import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';

final messagesRepository = Provider((ref) => MessagesRepository());

class MessagesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(MessageModel message) async {
    // TODO: FOR DEV
    const debugChatRoomsId = "48LjK8HLOuONJ8WgTyyb";
    await _firestore
        .collection("chat_rooms")
        .doc(debugChatRoomsId)
        .collection("texts")
        .add(message.toJson());
  }
}
