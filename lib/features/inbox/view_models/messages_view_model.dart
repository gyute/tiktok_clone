import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repository/messages_repository.dart';

final messagesProvider = AsyncNotifierProvider<MessagesViewModel, void>(
  () => MessagesViewModel(),
);

class MessagesViewModel extends AsyncNotifier<void> {
  late final MessagesRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(messagesRepository);
  }

  Future<void> sendMessage(String text, String chatRoomId) async {
    final user = ref.read(authRepository).user;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user!.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      _repository.sendMessage(message, chatRoomId);
    });
  }
}
