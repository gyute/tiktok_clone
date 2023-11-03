import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/utils.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  final List<int> _items = [];

  final Duration _duration = const Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 1,
            title: const Text("Inbox"),
            centerTitle: true,
            pinned: true,
            actions: [
              IconButton(
                // onPressed: _onDmPressed,
                onPressed: _addItem,
                icon: const FaIcon(
                  FontAwesomeIcons.paperPlane,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: ListTile(
              onTap: () {},
              leading: Container(
                width: Sizes.size56,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.users,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Text(
                "New followers",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.size16,
                ),
              ),
              subtitle: const Text(
                "Messages from followers will appear here",
                style: TextStyle(
                  fontSize: Sizes.size14,
                ),
              ),
              trailing: FaIcon(
                FontAwesomeIcons.chevronRight,
                size: Sizes.size16,
                color: isDarkMode(context) ? Colors.white : Colors.black,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ListTile(
              onTap: _onActivityTap,
              leading: Container(
                width: Sizes.size56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: const Center(
                  child: FaIcon(
                    FontAwesomeIcons.solidBell,
                    color: Colors.white,
                  ),
                ),
              ),
              title: const Text(
                "Activities",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: Sizes.size16,
                ),
              ),
              subtitle: const Text(
                "",
                style: TextStyle(
                  fontSize: Sizes.size14,
                ),
              ),
              trailing: FaIcon(
                FontAwesomeIcons.chevronRight,
                size: Sizes.size14,
                color: isDarkMode(context) ? Colors.white : Colors.black,
              ),
            ),
          ),
          // SliverList.builder(itemCount: ,itemBuilder: (context, index) {
          //
          // },),
          SliverAnimatedList(
            key: _listKey,
            itemBuilder: (context, index, animation) {
              return FadeTransition(
                key: UniqueKey(),
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: _makeTile(index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _addItem() {
    if (_listKey.currentState != null) {
      _listKey.currentState!.insertItem(
        _items.length,
        duration: _duration,
      );
      _items.add(_items.length);
    }
  }

  void _deleteItem(int index) {
    if (_listKey.currentState != null) {
      _listKey.currentState!.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: _makeTile(index),
        ),
        duration: _duration,
      );
      _items.remove(index);
    }
  }

  Widget _makeTile(int index) {
    return ListTile(
      onTap: () => _onChatTap(index),
      onLongPress: () => _deleteItem(index),
      leading: const CircleAvatar(
        radius: 30,
        foregroundImage: NetworkImage(
            "https://avatars.githubusercontent.com/u/15077948?v=4"),
        child: Text("GT"),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "M ($index)",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            "2:16 PM",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: Sizes.size12,
            ),
          )
        ],
      ),
      subtitle: const Text("Don't forget to message me"),
    );
  }

  void _onActivityTap() {
    context.pushNamed(ActivityScreen.routeName);
  }

  void _onChatTap(int index) {
    context.pushNamed(ChatDetailScreen.routeName);
  }
}
