// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// Escrito manualmente seguindo o padrão de saída do build_runner.
// Para regenerar: dart run build_runner build --delete-conflicting-outputs

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 1;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      nome: fields[0] as String,
      email: fields[1] as String,
      dataCadastro: fields[2] as String,
      pontuacao: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.dataCadastro)
      ..writeByte(3)
      ..write(obj.pontuacao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
