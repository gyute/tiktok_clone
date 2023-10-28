import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repository/messages_repository.dart';

final chatProvider = StreamProvider.autoDispose<List<MessageModel>>((ref) {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // TODO: FOR DEV
  const debugChatRoomsId = "48LjK8HLOuONJ8WgTyyb";

  return firestore
      .collection("chat_rooms")
      .doc(debugChatRoomsId)
      .collection("texts")
      .orderBy("createdAt")
      .snapshots()
      .map(
        (event) => event.docs
            .map(
              (doc) => MessageModel.fromJson(
                doc.data(),
              ),
            )
            .toList()
            .reversed
            .toList(),
      );
});

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(messagesRepository);
  }

  Future<void> sendMessage(String text) async {
    final user = ref.read(authRepository).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      _repository.sendMessage(message);
    });
  }
}
