import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/repository/user_repository.dart';

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  () => UsersViewModel(),
);

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<UserProfileModel> build() async {
    _userRepository = ref.read(userRepository);
    _authenticationRepository = ref.read(authRepository);

    if (_authenticationRepository.isLoggedIn) {
      final profile = await _userRepository
          .findProfile(_authenticationRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }

    return UserProfileModel.empty();
  }

  Future<void> createProfile(UserCredential credential,
      {String username = "Anonymous"}) async {
    if (credential.user == null) {
      throw Exception("Account not created");
    }
    state = const AsyncValue.loading();

    final profile = UserProfileModel(
      hasAvatar: false,
      uid: credential.user!.uid,
      email: credential.user!.email ?? "anonymous@anonymous.com",
      name: credential.user!.displayName ?? username,
      bio: "undefined",
      link: "Anonymous",
    );
    await _userRepository.createProfile(profile);

    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _userRepository.updateUser(state.value!.uid, {"hasAvatar": true});
  }
}
