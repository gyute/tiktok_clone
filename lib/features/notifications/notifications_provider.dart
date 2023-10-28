import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';

final notificationsProvider = AsyncNotifierProvider.family(
  () => NotificationsProvider(),
);

class NotificationsProvider extends FamilyAsyncNotifier<void, BuildContext> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  FutureOr build(BuildContext context) async {
    final token = await _messaging.getToken();
    if (token == null) return;
    await updateToken(token);

    if (!context.mounted) return;
    await initListeners(context);

    _messaging.onTokenRefresh.listen((newToken) async {
      await updateToken(newToken);
    });
  }

  Future<void> initListeners(BuildContext context) async {
    final permission = await _messaging.requestPermission();
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    // Foreground
    FirebaseMessaging.onMessage.listen((notification) {});

    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((notification) {});

    // Terminated
    final notification = await _messaging.getInitialMessage();
    if (notification != null) {}
  }

  Future<void> updateToken(String token) async {
    final user = ref.read(authRepository).user;
    await _firestore
        .collection("users")
        .doc(user!.uid)
        .update({"token": token});
  }
}
