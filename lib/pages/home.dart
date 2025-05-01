import 'package:conectraponto/pages/adiciona_foto.dart';
import 'package:conectraponto/pages/db/databse_helper.dart';
import 'package:conectraponto/pages/models/user.model.dart';
import 'package:conectraponto/pages/tabs/config_tab.dart';
import 'package:conectraponto/pages/tabs/inicio_tab.dart';
import 'package:conectraponto/pages/tabs/recibos_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  DatabaseHelper _dbHelper = DatabaseHelper.instance;

  final List<Widget> _tabs = [
    const InicioTab(),
    const RecibosTab(),
    const ConfiguracoesTab(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _verificarFotoUsuario();
  }

  void _verificarFotoUsuario() async {
    List<User> users = await _dbHelper.queryAllUsers();

    final usuario = users[0];
    print('#####################################################');
    print(usuario);
    print('#####################################################');
    if (usuario != null && (usuario.foto == null || usuario.foto!.isEmpty)) {
      print('aqui');
      final fotoAtualizada = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdicionaFoto()),
      );

      if (fotoAtualizada == true) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Recibos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
