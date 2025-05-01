import 'dart:io';
import 'package:conectraponto/pages/models/user.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final tableUsers = 'users';
  static final columnId = 'id';
  static final columnUser = 'user';
  static final columnNome = 'nome';
  static final columnEmail = 'email';
  static final columnFoto = 'foto';
  static final columnPassword = 'password';
  static final columnModelData = 'model_data';

  static final tableEmpresas = 'empresas';
  static final columnEmpresaId = 'id';
  static final columnEmpresaNome = 'nome';

  static final tablePontos = 'pontos';
  static final columnPontoId = 'id';
  static final columnUserId = 'user_id';
  static final columnData = 'data';
  static final columnHora = 'hora';
  static final columnEnviado = 'enviado';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _database;
  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE $tableUsers (
        $columnId INTEGER PRIMARY KEY,
        $columnUser TEXT NOT NULL,
        $columnNome TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnFoto TEXT,
        $columnPassword TEXT NOT NULL,
        $columnModelData TEXT
      )
    ''');

    // Tabela de empresas
    await db.execute('''
      CREATE TABLE $tableEmpresas (
        $columnEmpresaId TEXT PRIMARY KEY,
        $columnEmpresaNome TEXT NOT NULL
      )
    ''');

    // Tabela de pontos
    await db.execute('''
      CREATE TABLE $tablePontos (
        $columnPontoId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnUserId INTEGER,
        $columnData TEXT,
        $columnHora TEXT,
        $columnEnviado INTEGER
      )
    ''');

    // await _criarBaseInicial(db);
  }

  Future<void> _criarBaseInicial(Database db) async {
    // Criar empresa
    await db.insert(tableEmpresas, {
      columnEmpresaId: 'empresa_001',
      columnEmpresaNome: 'Empresa Teste',
    });

    // Criar usuário
    int userId = await db.insert(tableUsers, {
      columnUser: 'usuario@teste.com',
      columnPassword: '123456',
      columnModelData: '', // pode ajustar depois
    });

    // Criar 3 pontos
    final pontos = [
      {'user_id': userId, 'data': '2025-04-29', 'hora': '08:00', 'enviado': 1},
      {'user_id': userId, 'data': '2025-04-29', 'hora': '12:00', 'enviado': 1},
      {'user_id': userId, 'data': '2025-04-29', 'hora': '14:00', 'enviado': 0},
    ];

    for (var ponto in pontos) {
      await db.insert(tablePontos, ponto);
    }
  }

  Future<int> insert(User user) async {
    Database db = await instance.database;
    return await db.insert(tableUsers, user.toMap());
  }

  Future<List<User>> queryAllUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query(tableUsers);
    return users.map((u) => User.fromMap(u)).toList();
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(tableUsers);
  }
}
