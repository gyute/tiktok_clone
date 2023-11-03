import 'package:tiktok_clone/features/inbox/models/message_model.dart';

class ChatDetailModel {
  final String chatRoomId;
  final Map<String, dynamic> user1;
  final Map<String, dynamic> user2;
  MessageModel lastMessage;

  ChatDetailModel({
    required this.chatRoomId,
    required this.user1,
    required this.user2,
    required this.lastMessage,
  });
}
