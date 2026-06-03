import 'package:hive/hive.dart';

part 'user_profile.g.dart';

/// Modelo de perfil do usuário armazenado no Hive.
/// O TypeAdapter é gerado pelo build_runner (user_profile.g.dart).
@HiveType(typeId: 1)
class UserProfile extends HiveObject {
  @HiveField(0)
  String nome;

  @HiveField(1)
  String email;

  @HiveField(2)
  String dataCadastro; // formato: 'YYYY-MM-DD'

  @HiveField(3)
  int pontuacao;

  UserProfile({
    required this.nome,
    required this.email,
    required this.dataCadastro,
    this.pontuacao = 0,
  });

  @override
  String toString() =>
      'UserProfile(nome: $nome, email: $email, '
      'dataCadastro: $dataCadastro, pontuacao: $pontuacao)';
}
