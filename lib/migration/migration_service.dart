import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../models/user_profile.dart';

class MigrationService {
  static const int _currentVersion = 2;

  Future<void> migrate() async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt('data_version') ?? 1;

    if (storedVersion < _currentVersion) {
      await _migrateV1toV2(prefs);
      await prefs.setInt('data_version', _currentVersion);
    }
  }

  Future<void> _migrateV1toV2(SharedPreferences prefs) async {
    final oldNome = prefs.getString('user_name');
    final oldEmail = prefs.getString('user_email');

    if (oldNome != null && oldEmail != null) {
      final box = Hive.box<UserProfile>('profiles');

      if (box.isEmpty) {
        await box.add(UserProfile(
          nome: oldNome,
          email: oldEmail,
          dataCadastro: DateTime.now().toIso8601String().substring(0, 10),
          pontuacao: 0,
        ));
      }

      await prefs.remove('user_name');
      await prefs.remove('user_email');
    }
  }
}
