import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../models/user_profile.dart';

/// Serviço de migração de dados entre versões do app.
///
/// Versão 1: dados do usuário salvos com chaves avulsas no SharedPreferences
///           ('user_name', 'user_email').
/// Versão 2: dados consolidados em um UserProfile tipado no Hive.
///
/// A versão atual dos dados é rastreada na chave 'data_version' do SharedPreferences.
class MigrationService {
  static const int _currentVersion = 2;

  /// Verifica a versão dos dados e executa a migração necessária.
  Future<void> migrate() async {
    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt('data_version') ?? 1;

    if (storedVersion < _currentVersion) {
      await _migrateV1toV2(prefs);
      await prefs.setInt('data_version', _currentVersion);
    }
  }

  /// Migra dados no formato v1 (chaves avulsas no SharedPreferences)
  /// para o formato v2 (objeto UserProfile no Hive).
  Future<void> _migrateV1toV2(SharedPreferences prefs) async {
    final oldNome = prefs.getString('user_name');
    final oldEmail = prefs.getString('user_email');

    // Só migra se existirem dados legados e o box Hive estiver vazio
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

      // Remove as chaves legadas após migração
      await prefs.remove('user_name');
      await prefs.remove('user_email');
    }
  }
}
