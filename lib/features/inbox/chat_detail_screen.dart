import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/features/inbox/models/chat_detail_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/chat_detail_view_model.dart';
import 'package:tiktok_clone/features/inbox/view_models/messages_view_model.dart';
import 'package:tiktok_clone/utils.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = "/chatDetail";

  final ChatDetailModel detail;

  const ChatDetailScreen({
    super.key,
    required this.detail,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: bool.parse(widget.detail.user2["hasAvatar"].toString())
              ? CircleAvatar(
                  radius: Sizes.size24,
                  foregroundImage:
                      NetworkImage(getAvatarUrl(widget.detail.user2["uid"])),
                  child: Text(
                    widget.detail.user2["name"],
                    style: const TextStyle(fontSize: Sizes.size12),
                    textAlign: TextAlign.center,
                  ),
                )
              : CircleAvatar(
                  radius: Sizes.size24,
                  backgroundColor:
                      isDarkMode(context) ? Colors.white : Colors.black,
                  foregroundColor:
                      isDarkMode(context) ? Colors.black : Colors.white,
                  child: Text(
                    widget.detail.user2["name"],
                    style: const TextStyle(fontSize: Sizes.size12),
                    textAlign: TextAlign.center,
                  ),
                ),
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: Sizes.size8,
          title: Text(
            widget.detail.user2["name"],
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: const Text("Active now"),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FaIcon(
                FontAwesomeIcons.flag,
                color: Colors.black,
                size: Sizes.size20,
              ),
              Gaps.h32,
              FaIcon(
                FontAwesomeIcons.ellipsis,
                color: Colors.black,
                size: Sizes.size20,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ref.watch(chatProvider(widget.detail.chatRoomId)).when(
                data: (data) {
                  return ListView.separated(
                    reverse: true,
                    padding: EdgeInsets.only(
                      top: Sizes.size20,
                      left: Sizes.size14,
                      right: Sizes.size20,
                      bottom:
                          MediaQuery.of(context).padding.bottom + Sizes.size96,
                    ),
                    itemBuilder: (context, index) {
                      final message = data[index];
                      final isMine =
                          message.userId == ref.watch(authRepository).user!.uid;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: isMine
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(
                              Sizes.size14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(
                                  Sizes.size20,
                                ),
                                topRight: const Radius.circular(
                                  Sizes.size20,
                                ),
                                bottomLeft: Radius.circular(
                                  isMine ? Sizes.size20 : Sizes.size5,
                                ),
                                bottomRight: Radius.circular(
                                  isMine ? Sizes.size5 : Sizes.size20,
                                ),
                              ),
                              color: isMine
                                  ? Colors.blue
                                  : Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              message.text,
                              style: const TextStyle(
                                fontSize: Sizes.size16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => Gaps.v10,
                    itemCount: data.length,
                  );
                },
                error: (error, stackTrace) => Center(
                  child: Text(
                    error.toString(),
                  ),
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: BottomAppBar(
              color: Colors.grey.shade50,
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _editingController,
                    decoration: InputDecoration(
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Sizes.size12,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size12,
                      ),
                    ),
                  )),
                  Gaps.h20,
                  IconButton(
                    onPressed: isLoading ? null : _onSendPress,
                    icon: FaIcon(
                      isLoading
                          ? FontAwesomeIcons.hourglass
                          : FontAwesomeIcons.paperPlane,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onSendPress() {
    final text = _editingController.text;
    if (text == "") {
      return;
    }

    ref
        .read(messagesProvider.notifier)
        .sendMessage(text, widget.detail.chatRoomId);
    _editingController.text = "";
  }
}
