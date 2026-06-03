import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Gerencia as preferências do usuário usando SharedPreferences.
/// Estende ChangeNotifier para integrar com o Provider e refletir mudanças
/// na UI imediatamente (ex: troca de tema escuro/claro).
class SettingsService extends ChangeNotifier {
  // Chaves utilizadas no SharedPreferences
  static const _keyDarkMode = 'dark_mode';
  static const _keyLanguage = 'language';
  static const _keyNotifications = 'notifications';

  bool _darkMode = false;
  String _language = 'Português';
  bool _notifications = true;

  // ---------- Getters ----------

  bool get darkMode => _darkMode;
  String get language => _language;
  bool get notifications => _notifications;

  // ---------- Carregamento inicial ----------

  /// Lê todas as preferências salvas e notifica os widgets ouvintes.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool(_keyDarkMode) ?? false;
    _language = prefs.getString(_keyLanguage) ?? 'Português';
    _notifications = prefs.getBool(_keyNotifications) ?? true;
    notifyListeners();
  }

  // ---------- Setters com persistência ----------

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyLanguage, value);
    notifyListeners();
  }

  Future<void> setNotifications(bool value) async {
    _notifications = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifications, value);
    notifyListeners();
  }
}
