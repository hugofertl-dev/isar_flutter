import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'entities/usuario_model.dart';
import 'provider/isar.dart';
import 'provider/isar_generica.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final isarProvider = IsarProvider();
  // final isarProvider = IsarProviderGenerica();
  late Isar isar;
  List<UsuarioModel> lstUsuarios = [];
  bool initIsar = false;

  @override
  void initState() {
    super.initState();
    if (!initIsar) {
      inicializaISar();
    }
  }

  Future<void> inicializaISar() async {
    isar = await isarProvider.database;
    setState(() {
      initIsar = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Isar Ejemplo'),
        ),
        body: (!initIsar)
            ? const Center(child: Text('Inicializando Isar'))
            : Center(
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          // if (isar != null) {
                          //   final usuario = UsuarioModel(
                          //       nombre: 'Juan',
                          //       apellido: 'No se quien',
                          //       mail: 'juan_nose@gmail.com');

                          //   final lstusuario = await isarProvider.getData(
                          //       coleccion: isar!.usuarioModels,
                          //       indexNames: ['mail'],
                          //       operador: ['='],
                          //       values: [usuario.mail]) as List<UsuarioModel>;
                          //   UsuarioModel usuarioExiste = UsuarioModel();
                          //   if (lstusuario.isNotEmpty) {
                          //     usuarioExiste = lstusuario.first;
                          //   }
                          //   if (usuarioExiste.mail != usuario.mail) {
                          //     final respuesta = await isarProvider.guarda(
                          //         data: usuario,
                          //         coleccion: isar!.usuarioModels);
                          //     if (respuesta > 0) {
                          //       lstUsuarios = [
                          //         ...await isarProvider.getAllData(
                          //             coleccion: isar!.usuarioModels)
                          //       ];
                          //       setState(() {});
                          //     }
                          //   }
                          // }
                          final usuario = UsuarioModel(
                              nombre: 'Luciana',
                              apellido: 'Artigas',
                              mail: 'lartigas@gmail.com');

                          final usuarioExiste = await isarProvider
                              .getUsuarioByMail(mail: usuario.mail);
                          if (usuarioExiste.mail != usuario.mail) {
                            final respuesta = await isarProvider.guardarUsuario(
                                usaurio: usuario);
                            if (respuesta > 0) {
                              lstUsuarios = await isarProvider.getAllUsuarios();
                              setState(() {});
                            }
                          }
                        },
                        child: const Text('Agrega Usuario')),
                    ElevatedButton(
                        onPressed: () async {
                          // lstUsuarios = [
                          //   ...await isarProvider.getAllData(
                          //       coleccion: isar!.usuarioModels)
                          // ];
                          lstUsuarios = await isarProvider.getAllUsuarios();
                          setState(() {});
                        },
                        child: const Text('Obtiene Usuarios')),
                    if (lstUsuarios.isNotEmpty)
                      Expanded(
                        child: cargalista(lstUsuarios),
                      )
                  ],
                ),
              ),
      ),
    );
  }
}

Widget cargalista(List<UsuarioModel> lstUsuarios) {
  return ListView.builder(
    itemCount: lstUsuarios.length,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        leading: Text(
            '${lstUsuarios[index].nombre}.. ${lstUsuarios[index].apellido}'),
        title: Text(lstUsuarios[index].mail),
      );
    },
  );
}
