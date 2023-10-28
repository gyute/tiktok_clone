import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

final videosRepository = Provider((ref) => VideosRepository());

class VideosRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchVideos({
    int? lastItemCreatedAt,
  }) {
    final query = _firestore
        .collection("videos")
        .orderBy("createdAt", descending: true)
        .limit(2);

    if (lastItemCreatedAt == null) {
      return query.get();
    } else {
      return query.startAfter([lastItemCreatedAt]).get();
    }
  }

  Future<void> saveVideo(VideoModel data) async {
    await _firestore.collection("videos").add(data.toJson());
  }

  Future<void> toggleLikeVideo(String videoId, String userId) async {
    // `like Id` is also used as an ID in `Cloud functions`
    final likesId = "${userId}000$videoId";
    final query = _firestore.collection("likes").doc(likesId);

    final like = await query.get();

    if (!like.exists) {
      await query.set(
        {
          "createdAt": DateTime.now().millisecondsSinceEpoch,
        },
      );
    } else {
      await query.delete();
    }
  }

  UploadTask uploadVideoFile(File video, String uid) {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final fileRef = _storage.ref().child("/video/$uid/$fileName");

    return fileRef.putFile(video);
  }
}
