import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/features/users/repository/user_repository.dart';
import 'package:tiktok_clone/features/users/view_models/user_view_models.dart';

final avatarProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  AvatarViewModel.new,
);

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepository);
  }

  Future<void> uploadAvatar(File file) async {
    state = const AsyncValue.loading();

    final fileName = ref.read(authRepository).user!.uid;

    state = await AsyncValue.guard(
      () async {
        await _repository.uploadAvatar(file, fileName);
        await ref.read(usersProvider.notifier).onAvatarUpload();
      },
    );
  }
}
