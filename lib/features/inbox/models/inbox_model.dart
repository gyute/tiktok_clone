import 'package:tiktok_clone/features/inbox/models/chat_detail_model.dart';

class InboxModel {
  final String uid;
  final List<String> followers;
  final List<ChatDetailModel> chatDetail;

  InboxModel({
    required this.uid,
    required this.followers,
    required this.chatDetail,
  });

  InboxModel.empty()
      : uid = "",
        followers = [],
        chatDetail = [];
}
