import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/features/users/view_models/avatar_view_model.dart';

class Avatar extends ConsumerWidget {
  final String uid;
  final String name;
  final bool hasAvatar;

  const Avatar({
    super.key,
    required this.uid,
    required this.name,
    required this.hasAvatar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(avatarProvider).isLoading;
    final avatarURL =
        "https://firebasestorage.googleapis.com/v0/b/tiktok-gt.appspot.com/o/avatars%2F$uid?alt=media&forUpdate=${DateTime.now().toString()}";

    return GestureDetector(
      onTap: isLoading ? null : () => _onAvatarTap(ref),
      child: isLoading
          ? Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator.adaptive(),
            )
          : CircleAvatar(
              radius: 50,
              foregroundImage: hasAvatar ? NetworkImage(avatarURL) : null,
              child: Text(name),
            ),
    );
  }

  Future<void> _onAvatarTap(WidgetRef ref) async {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxHeight: 150,
      maxWidth: 150,
    );

    if (xFile != null) {
      final file = File(xFile.path);
      ref.read(avatarProvider.notifier).uploadAvatar(file);
    }
  }
}
