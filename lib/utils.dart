import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String getAvatarUrl(String uid) {
  return "https://firebasestorage.googleapis.com/v0/b/tiktok-gt.appspot.com/"
      "o/avatars%2F$uid?alt=media";
}

bool isDarkMode(BuildContext context) =>
    MediaQuery.of(context).platformBrightness == Brightness.dark;

void showFirebaseErrorSnack(
  BuildContext context,
  Object? error,
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      content: Text(
        (error as FirebaseException).message ?? "Something wen't wrong.",
      ),
    ),
  );
}

String timeWithAmPmMarker(DateTime dateTime) {
  return DateFormat("kk:mm a").format(dateTime);
}
