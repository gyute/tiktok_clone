import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

final userRepository = Provider((ref) => UserRepository());

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createProfile(UserProfileModel profile) async {
    await _firestore.collection("users").doc(profile.uid).set(profile.toJson());
  }

  Future<Map<String, dynamic>?> findProfile(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();
    return doc.data();
  }

  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    await _firestore.collection("users").doc(uid).update(data);
  }

  Future<void> uploadAvatar(File file, String fileName) async {
    final fileRef = _storage.ref().child("avatars/$fileName");
    await fileRef.putFile(file);
  }
}
