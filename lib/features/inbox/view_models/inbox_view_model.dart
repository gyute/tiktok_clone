import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/chat_detail_model.dart';
import 'package:tiktok_clone/features/inbox/models/inbox_model.dart';
import 'package:tiktok_clone/features/inbox/repository/chat_detail_repository.dart';

final inboxProvider =
    AsyncNotifierProvider<InboxViewModel, InboxModel>(InboxViewModel.new);

class InboxViewModel extends AsyncNotifier<InboxModel> {
  late final AuthenticationRepository _authenticationRepository;
  late final List<ChatDetailModel> chatRooms = [];
  late final String uid;

  @override
  FutureOr<InboxModel> build() async {
    _authenticationRepository = ref.read(authRepository);
    uid = _authenticationRepository.user!.uid;
    await ref
        .read(chatDetailRepositoryProvider.notifier)
        .getChatRooms(uid)
        .then((chatDetails) {
      for (var detail in chatDetails) {
        chatRooms.add(detail);
      }
    });

    if (_authenticationRepository.isLoggedIn) {
      return InboxModel(uid: uid, followers: [], chatDetail: chatRooms);
    }

    return InboxModel.empty();
  }
}
