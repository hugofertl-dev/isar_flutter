import 'package:isar/isar.dart';

import '../entities/usuario_model.dart';

class IsarProviderGenerica<T> {
  static late Isar _isar;

  Future<Isar> get database async {
    _isar = await openDB();
    return _isar;
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([UsuarioModelSchema], inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  Future<int> guarda(
      {required T data, required IsarCollection<T> coleccion}) async {
    return _isar.writeTxnSync<int>(() => coleccion.putSync(data));
  }

  Future<List<T>> getAllData({required IsarCollection<T> coleccion}) async {
    return await coleccion.where().findAll();
  }

  Future<List<T>> getData(
      {required IsarCollection<T> coleccion,
      required List<String> indexNames,
      required List<String> operador,
      required List<String> values}) async {
    try {
      if ((indexNames.length + operador.length + values.length) !=
          (indexNames.length * 3)) return [];

      final List<WhereClause> lstWhereClause = [];
      int index = -1;
      for (String indexName in indexNames) {
        index++;
        switch (operador[index]) {
          case '=':
            lstWhereClause.add(IndexWhereClause.equalTo(
                indexName: indexName, value: [values[index]]));
            break;
          case '>':
            lstWhereClause.add(IndexWhereClause.greaterThan(
                indexName: indexName,
                lower: [values[index]],
                includeLower: false));
            break;
          case '>=':
            lstWhereClause.add(IndexWhereClause.greaterThan(
                indexName: indexName, lower: [values[index]]));
            break;
          case '<':
            lstWhereClause.add(IndexWhereClause.lessThan(
                indexName: indexName,
                upper: [values[index]],
                includeUpper: false));
            break;
          case '<=':
            lstWhereClause.add(IndexWhereClause.lessThan(
                indexName: indexName, upper: [values[index]]));
            break;

          default:
        }
      }
      final respuesta =
          await coleccion.buildQuery(whereClauses: lstWhereClause).findAll();
      if (respuesta.isNotEmpty) {
        final List<T> lista = [...respuesta];
        return lista;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Stream<List<T>> listenToNewData(
      {required IsarCollection<T> function}) async* {
    yield* function.where().watch(fireImmediately: true);
  }
}
