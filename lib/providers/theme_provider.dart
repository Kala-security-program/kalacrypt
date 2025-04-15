import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isCyberpunk;

  ThemeProvider(this._isCyberpunk);

  bool get isCyberpunk => _isCyberpunk;

  ThemeData get themeData => _isCyberpunk ? cyberpunkTheme : standardDarkTheme;

  Future<void> toggleTheme(bool cyberpunk) async {
    _isCyberpunk = cyberpunk;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCyberpunk', cyberpunk);
  }

  static Future<ThemeProvider> create() async {
    final prefs = await SharedPreferences.getInstance();
    final isCyber = prefs.getBool('isCyberpunk') ?? true;
    return ThemeProvider(isCyber);
  }
}
