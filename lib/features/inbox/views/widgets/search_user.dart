import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/models/chat_detail_model.dart';
import 'package:tiktok_clone/features/inbox/models/message_model.dart';
import 'package:tiktok_clone/features/inbox/repository/inbox_repository.dart';
import 'package:tiktok_clone/features/users/view_models/user_view_models.dart';
import 'package:tiktok_clone/utils.dart';

class SearchUser extends ConsumerStatefulWidget {
  const SearchUser({super.key});

  @override
  ConsumerState<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends ConsumerState<SearchUser> {
  final TextEditingController _textEditingController = TextEditingController();

  Map<String, dynamic>? user;

  int? selectedOption;

  @override
  Widget build(BuildContext context) {
    final isDark = isDarkMode(context);

    return SizedBox(
      child: Scaffold(
        backgroundColor: isDark ? null : Colors.grey.shade50,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: AppBar(
            backgroundColor: isDark ? null : Colors.grey.shade50,
            automaticallyImplyLeading: false,
            title: const Text(
              "Create a new chat",
            ),
            actions: [
              IconButton(
                onPressed: _onClosePressed,
                icon: const FaIcon(FontAwesomeIcons.xmark),
              )
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: _onChanged,
                    textInputAction: TextInputAction.newline,
                    // expands: true,
                    minLines: null,
                    maxLines: null,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      prefixIconConstraints: const BoxConstraints(maxWidth: 50),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(
                          left: 10,
                          right: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: 14,
                            )
                          ],
                        ),
                      ),
                      hintText: "Search friends",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          Sizes.size12,
                        ),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor:
                          isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        // HACK: If put a vertical padding, not display even if it is newline
                        // vertical: Sizes.size12,
                        horizontal: Sizes.size10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Stack(children: [
          user != null
              ? _foundFriend(context, user!)
              : const Center(
                  child: Text(
                    "Let's find friends!",
                    style: TextStyle(fontSize: Sizes.size20),
                  ),
                ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _onChanged(String value) async {
    if (value != "") {
      user = await ref.read(createChatProvider).getUserByEmail(value);
    } else {
      user = null;
    }
    setState(() {});
  }

  void _onChatTap(
      BuildContext context, Map<String, dynamic> oppositeUser) async {
    final mine = ref.read(usersProvider).value;

    final chatRoomId = await ref
        .read(createChatProvider)
        .createChat(mine!.uid, oppositeUser["uid"]);

    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    context
        .pushNamed(
          ChatDetailScreen.routeName,
          extra: ChatDetailModel(
            chatRoomId: chatRoomId,
            user1: mine.toJson(),
            user2: oppositeUser,
            lastMessage: MessageModel(text: "", userId: mine.uid, createdAt: 0),
          ),
        )
        .whenComplete(() => context.pop());
  }

  void _onClosePressed() {
    Navigator.of(context).pop();
  }

  Widget _foundFriend(BuildContext context, Map<String, dynamic> user) {
    return ListTile(
      onTap: () => {},
      leading: bool.parse(user["hasAvatar"].toString())
          ? CircleAvatar(
              radius: 30,
              foregroundImage: NetworkImage(getAvatarUrl(user["uid"])),
              child: Text(
                user["name"],
                style: const TextStyle(fontSize: Sizes.size12),
                textAlign: TextAlign.center,
              ),
            )
          : CircleAvatar(
              radius: 30,
              backgroundColor:
                  isDarkMode(context) ? Colors.white : Colors.black,
              foregroundColor:
                  isDarkMode(context) ? Colors.black : Colors.white,
              child: Text(
                user["name"],
                style: const TextStyle(fontSize: Sizes.size12),
                textAlign: TextAlign.center,
              ),
            ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${user["name"]}",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      subtitle: Text(
        user["email"],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Radio(
        value: 1,
        groupValue: selectedOption,
        toggleable: true,
        onChanged: (value) {
          if (value == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: isDarkMode(context)
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
                duration: const Duration(days: 1),
                // showCloseIcon: true,
                content: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            bool.parse(user["hasAvatar"].toString())
                                ? CircleAvatar(
                                    radius: 30,
                                    foregroundImage:
                                        NetworkImage(getAvatarUrl(user["uid"])),
                                    child: Text(
                                      user["name"],
                                      style: const TextStyle(
                                          fontSize: Sizes.size12),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    backgroundColor: isDarkMode(context)
                                        ? Colors.white
                                        : Colors.black,
                                    foregroundColor: isDarkMode(context)
                                        ? Colors.black
                                        : Colors.white,
                                    child: Text(
                                      user["name"],
                                      style: const TextStyle(
                                          fontSize: Sizes.size12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                            Text(
                              "${user["name"]}",
                              style: TextStyle(
                                fontSize: Sizes.size12,
                                color: isDarkMode(context)
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            )
                          ],
                        ),
                        Gaps.v16,
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                minimumSize: const Size(200, 40)),
                            onPressed: () => _onChatTap(context, user),
                            child: const Text(
                              "Chat",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }
          setState(() {
            selectedOption = value;
          });
        },
      ),
    );
  }
}
