import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_profile.dart';

/// Serviço responsável por inicializar o Hive e registrar todos os adapters.
class StorageService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Registra o adapter gerado pelo build_runner
    Hive.registerAdapter(UserProfileAdapter());

    // Abre o box de perfis de usuário
    await Hive.openBox<UserProfile>('profiles');
  }
}
