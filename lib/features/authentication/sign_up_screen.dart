import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/intl_generated.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/authentication/view_model/social_auth_view_model.dart';
import 'package:tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:tiktok_clone/utils.dart';

class SignUpScreen extends ConsumerWidget {
  static const routeURL = "/";
  static const routeName = "signUp";
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.size40,
          ),
          child: Column(
            children: [
              Gaps.v80,
              Opacity(
                opacity: 0.7,
                child: Text(
                  AppLocalizations.of(context)!.signUpTitle(
                    "TikTok",
                    DateTime.now(),
                  ),
                  style: const TextStyle(
                    fontSize: Sizes.size24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Gaps.v20,
              Opacity(
                opacity: 0.7,
                child: Text(
                  AppLocalizations.of(context)!.signUpSubtitle(2),
                  style: const TextStyle(
                    fontSize: Sizes.size14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.v40,
              Tooltip(
                message: "Use email & password",
                child: GestureDetector(
                  onTap: () => _onEmailTap(context),
                  child: AuthButton(
                      icon: const FaIcon(FontAwesomeIcons.user),
                      text: AppLocalizations.of(context)!.emailPasswordButton),
                ),
              ),
              Gaps.v16,
              Tooltip(
                message: "Use Github account",
                child: GestureDetector(
                  onTap: () => ref
                      .read(socialAuthProvider.notifier)
                      .githubSignIn(context),
                  child: const AuthButton(
                      icon: FaIcon(FontAwesomeIcons.github),
                      text: 'Continue with Github'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: isDarkMode(context) ? null : Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.only(
            top: Sizes.size32,
            bottom: Sizes.size64,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.alreadyHaveAnAccount),
              Gaps.h5,
              Tooltip(
                message: "Log in",
                child: GestureDetector(
                  onTap: () => _onLoginTap(context),
                  child: Text(
                    AppLocalizations.of(context)!.login("Martian"),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onEmailTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UsernameScreen(),
      ),
    );
  }

  void _onLoginTap(BuildContext context) {
    context.pushNamed(LoginScreen.routeName);
  }
}
