import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/utils.dart';

final socialAuthProvider =
    AsyncNotifierProvider<SocialAuthViewModel, void>(SocialAuthViewModel.new);

class SocialAuthViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepository);
  }

  Future<void> githubSignIn(BuildContext context) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async => await _repository.githubSignIn(),
    );

    if (state.hasError) {
      if (!context.mounted) return;
      showFirebaseErrorSnack(context, state.error);
    } else {
      if (!context.mounted) return;
      context.go("/home");
    }
  }
}
