import 'package:isar/isar.dart';

import '../entities/usuario_model.dart';

class IsarProvider {
  static late Isar _isar;

  Future<Isar> get database async {
    _isar = await openDb();
    return _isar;
  }

  Future<Isar> openDb() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([UsuarioModelSchema], inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  Future<int> guardarUsuario({required UsuarioModel usaurio}) async {
    return _isar.writeTxnSync<int>(() => _isar.usuarioModels.putSync(usaurio));
  }

  Future<List<UsuarioModel>> getAllUsuarios() async {
    return _isar.usuarioModels.where().findAll();
  }

  Stream<List<UsuarioModel>> listenToNewUsuario() async* {
    yield* _isar.usuarioModels.where().watch(fireImmediately: true);
  }

  Future<UsuarioModel> getUsuarioByMail({required String mail}) async {
    final respuesta =
        await _isar.usuarioModels.filter().mailEqualTo(mail).findAll();
    if (respuesta.isNotEmpty) {
      return respuesta.first;
    }
    return UsuarioModel();
  }
}
