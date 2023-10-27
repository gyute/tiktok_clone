import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/features/users/view_models/user_view_models.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/repositories/videos_repository.dart';

final uploadVideoProvider = AsyncNotifierProvider<UploadVideoViewModel, void>(
    () => UploadVideoViewModel());

class UploadVideoViewModel extends AsyncNotifier<void> {
  late final VideosRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videosRepository);
  }

  Future<void> uploadVideo(File video, BuildContext context) async {
    final user = ref.read(authRepository).user;
    final userProfile = ref.read(usersProvider).value;
    if (userProfile != null) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() async {
        final task = await _repository.uploadVideoFile(video, user!.uid);

        if (task.metadata != null) {
          await _repository.saveVideo(
            VideoModel(
              id: "",
              title: "From Flutter",
              description: "YES",
              fileUrl: await task.ref.getDownloadURL(),
              thumbnailUrl: "",
              creatorUid: user.uid,
              creator: userProfile.name,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              likes: 0,
              commnets: 0,
            ),
          );

          if (!context.mounted) return;
          // Back to the camera screen
          context.pop();
          // Back to the main navigator screen
          context.pop();
        }
      });
    }
  }
}
