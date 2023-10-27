import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

final videosRepository = Provider((ref) => VideosRepository());

class VideosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos() {
    return _firestore
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .get();
  }

  Future<void> saveVideo(VideoModel data) async {
    await _firestore.collection("videos").add(data.toJson());
  }

  UploadTask uploadVideoFile(File video, String uid) {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final fileRef = _storage.ref().child("/video/$uid/$fileName");

    return fileRef.putFile(video);
  }
}
