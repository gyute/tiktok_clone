import 'package:shared_preferences/shared_preferences.dart';

class VideoPlaybackConfigRepository {
  static const String _autoplay = "autoplay";
  static const String _muted = "muted";

  final SharedPreferences _preferences;

  VideoPlaybackConfigRepository(this._preferences);

  bool isAutoplay() {
    return _preferences.getBool(_autoplay) ?? false;
  }

  bool isMuted() {
    return _preferences.getBool(_muted) ?? false;
  }

  Future<void> setAutoplay(bool value) async {
    _preferences.setBool(_autoplay, value);
  }

  Future<void> setMuted(bool value) async {
    _preferences.setBool(_muted, value);
  }
}
