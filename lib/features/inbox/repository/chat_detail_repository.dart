import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_detail_model.dart';

final chatDetailRepositoryProvider =
    AsyncNotifierProvider<ChatDetailRepository, void>(
        () => ChatDetailRepository());

class ChatDetailRepository extends AsyncNotifier<void> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  FutureOr<void> build() {}

  Future<List<ChatDetailModel>> getChatRooms(String userId) async {
    final chatRooms = await _firestore
        .collection("chat_rooms")
        .where(
          Filter.or(
            Filter('userA', isEqualTo: userId),
            Filter('userB', isEqualTo: userId),
          ),
        )
        .get();

    final List<ChatDetailModel> list = [];

    for (var doc in chatRooms.docs) {
      list.add(
        ChatDetailModel(
          chatRoomId: doc.id,
          userAId: doc.data()["userA"],
          userBId: doc.data()["userA"],
        ),
      );
    }

    return list;
  }
}
