import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repository/user_repository.dart';

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepository);
    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();

    final profile = UserProfileModel(
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anonymous@anonymous.com",
      name: credential.user!.displayName ?? "Anonymous",
      bio: "undefined",
      link: "Anonymous",
    );
    await _repository.createProfile(profile);

    state = AsyncValue.data(profile);
  }
}
