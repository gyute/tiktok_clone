import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/users/view_models/user_view_models.dart';
import 'package:tiktok_clone/utils.dart';

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<void> build() {
    _authenticationRepository = ref.read(authRepository);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();

    final form = ref.read(signUpForm);

    final users = ref.read(usersProvider.notifier);

    state = await AsyncValue.guard(() async {
      final userCredential = await _authenticationRepository.emailSignUp(
        form["email"],
        form["password"],
      );
      await users.createProfile(userCredential, username: form["username"]);
    });

    if (state.hasError) {
      if (!context.mounted) return;
      showFirebaseErrorSnack(context, state.error);
    } else {
      if (!context.mounted) return;
      context.goNamed(InterestsScreen.routeName);
    }
  }
}
