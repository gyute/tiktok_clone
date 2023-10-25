import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authenticationRepository;

  @override
  FutureOr<void> build() {
    _authenticationRepository = ref.read(authRepository);
  }

  Future<void> signUp() async {
    state = AsyncValue.loading();

    final form = ref.read(signUpForm);

    state = await AsyncValue.guard(
      () async => await _authenticationRepository.signUp(
        form["email"],
        form["password"],
      ),
    );
  }
}

final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
