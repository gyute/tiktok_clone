import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repository/authentication_repository.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).muted,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setMuted(value),
            title: const Text("Mute video"),
            subtitle: const Text("Video will be muted by default."),
          ),
          SwitchListTile.adaptive(
            value: ref.watch(playbackConfigProvider).autoplay,
            onChanged: (value) =>
                ref.read(playbackConfigProvider.notifier).setAutoplay(value),
            title: const Text("Autoplay"),
            subtitle: const Text("Video will start playing automatically."),
          ),
          SwitchListTile.adaptive(
            value: false,
            onChanged: (valuse) {},
            title: const Text("Enable notifications"),
            subtitle: const Text("It will make you happy!"),
          ),
          CheckboxListTile(
            activeColor: Colors.black,
            value: false,
            onChanged: (valuse) {},
            title: const Text("Marketing emails"),
            subtitle: const Text("We won't spam you."),
          ),
          ListTile(
            onTap: () async {
              await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
              );
              await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              await showDateRangePicker(
                context: context,
                firstDate: DateTime(1980),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                      appBarTheme: const AppBarTheme(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
            },
            title: const Text("What is your birthday?"),
            subtitle: const Text("I need to know!"),
          ),
          ListTile(
            title: const Text("Log out"),
            textColor: Colors.red,
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text("Please don't go"),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("No"),
                    ),
                    CupertinoDialogAction(
                      // TODO: Consider directly referencing the repository in the view
                      onPressed: () {
                        ref.read(authRepository).signOut();
                        context.go("/");
                        Navigator.of(context).pop();
                      },
                      isDestructiveAction: true,
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              );
            },
          ),
          const AboutListTile(
            applicationVersion: "1.0",
            applicationLegalese: "Don't copy me.",
          ),
        ],
      ),
    );
  }
}
