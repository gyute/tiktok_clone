import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/chat_detail_model.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/users/repository/user_repository.dart';

final chatRoomsProvider = StreamProvider.autoDispose<List<ChatDetailModel>>(
  (ref) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final String uid = ref.read(authRepository).user!.uid;
    final UserRepository userRepo = ref.read(userRepository);

    return firestore
        .collection("chat_rooms")
        .where(
          Filter.or(
            Filter('user1', isEqualTo: uid),
            Filter('user2', isEqualTo: uid),
          ),
        )
        .snapshots()
        .asyncMap(
      (chatRooms) async {
        final list = chatRooms.docs.map(
          (doc) async {
            final userA = await userRepo.findProfile(doc.data()["user1"]);
            final userB = await userRepo.findProfile(doc.data()["user2"]);

            return ChatDetailModel(
              chatRoomId: doc.id,
              user1: userA!["uid"] == uid ? userA : userB!,
              user2: userB!["uid"] == uid ? userA : userB,
              // TODO: Update lastMessage
              lastMessage: MessageModel(text: "", userId: uid, createdAt: 0),
            );
          },
        );
        return await Future.wait(list);
      },
    );
  },
);
