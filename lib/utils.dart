import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
