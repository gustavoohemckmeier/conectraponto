import 'dart:convert';

class User {
  String user;
  String nome;
  String email;
  String password;
  String? foto;
  List? modelData;

  User({
    required this.user,
    required this.nome,
    required this.email,
    required this.password,
    this.foto,
    this.modelData,
  });

  static User fromMap(Map<String, dynamic> user) {
    return new User(
      user: user['user'],
      nome: user['nome'],
      email: user['email'],
      password: user['password'],
      foto: user['foto'],
      modelData: jsonDecode(user['model_data']),
    );
  }

  toMap() {
    return {
      'user': user,
      'nome': nome,
      'email': email,
      'password': password,
      'foto': foto,
      'model_data': jsonEncode(modelData),
    };
  }
}
