import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_detail_model.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/users/repository/user_repository.dart';

final chatDetailRepositoryProvider =
    AsyncNotifierProvider<ChatDetailRepository, void>(
        () => ChatDetailRepository());

class ChatDetailRepository extends AsyncNotifier<void> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final UserRepository _userRepository;

  @override
  FutureOr<void> build() {
    _userRepository = ref.read(userRepository);
  }

  Future<List<ChatDetailModel>> getChatRooms(String userId) async {
    final chatRooms = await _firestore
        .collection("chat_rooms")
        .where(
          Filter.or(
            Filter('user1', isEqualTo: userId),
            Filter('user2', isEqualTo: userId),
          ),
        )
        .get();

    final List<ChatDetailModel> list = [];

    for (var doc in chatRooms.docs) {
      final userA = await _userRepository.findProfile(doc.data()["user1"]);
      final userB = await _userRepository.findProfile(doc.data()["user2"]);

      // TODO: Update lastMessage
      list.add(
        ChatDetailModel(
          chatRoomId: doc.id,
          user1: userA!["uid"] == userId ? userA : userB!,
          user2: userB!["uid"] == userId ? userA : userB,
          lastMessage: MessageModel(text: "", userId: userId, createdAt: 0),
        ),
      );
    }

    return list;
  }
}
