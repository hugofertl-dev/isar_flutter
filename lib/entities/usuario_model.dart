import 'package:isar/isar.dart';

part 'usuario_model.g.dart';

@collection
class UsuarioModel {
  final Id id;
  @Index(unique: false, replace: false)
  final String nombre;
  @Index(unique: false, replace: false)
  final String apellido;
  @Index(unique: true, replace: true)
  final String mail;

  UsuarioModel({
    this.id = Isar.autoIncrement,
    this.nombre = '',
    this.apellido = '',
    this.mail = '',
  });

  UsuarioModel copyWith({String? nombre, String? apellido, String? mail}) =>
      UsuarioModel(
          nombre: nombre ?? this.nombre,
          apellido: apellido ?? this.apellido,
          mail: mail ?? this.mail);
}
