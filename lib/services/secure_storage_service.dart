import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Serviço para armazenamento seguro de dados sensíveis.
///
/// Utiliza o Keystore (Android) e Keychain (iOS) do sistema operacional,
/// garantindo criptografia em repouso. Adequado para tokens de autenticação,
/// chaves de API e outros dados que não podem ficar expostos no armazenamento
/// comum (SharedPreferences/Hive não são criptografados).
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _keyToken = 'auth_token';

  /// Salva um token de autenticação de forma segura e criptografada.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  /// Recupera o token salvo. Retorna null se nenhum token foi armazenado.
  Future<String?> readToken() async {
    return await _storage.read(key: _keyToken);
  }

  /// Remove o token do armazenamento seguro.
  Future<void> deleteToken() async {
    await _storage.delete(key: _keyToken);
  }
}
