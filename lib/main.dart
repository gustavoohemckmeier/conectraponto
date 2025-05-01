import 'package:conectraponto/locator.dart';
import 'package:conectraponto/pages/login.dart';
import 'package:conectraponto/pages/home.dart';
import 'package:conectraponto/providers/ponto_provider.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'providers/empresa_provider.dart';
import 'package:conectraponto/pages/widgets/carregamento_app.dart';
import 'package:flutter/material.dart';

void main() {
  setupServices();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => EmpresaProvider()),
      ChangeNotifierProvider(create: (_) => PontoProvider()),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String primeiroAcesso = 'nao';

  Widget _initPage = CarregamentoApp();

  Future<dynamic> _initSession() async {
    if (await _verifyLogoutUser()) {
      setState(() {
        _initPage = Login();
      });
    } else {
      setState(() {
        _initPage = MyHomePage();
      });
    }
  }

  _verifyLogoutUser() async {
    return true;

    // return false;
  }

  @override
  void initState() {
    super.initState();

    _initSession();
  }

  @override
  Widget build(BuildContext context) {
    return _initPage;
  }
}
