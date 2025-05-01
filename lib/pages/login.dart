import 'package:conectraponto/locator.dart';
import 'package:conectraponto/pages/db/databse_helper.dart';
import 'package:conectraponto/pages/home.dart';
import 'package:conectraponto/pages/models/user.model.dart';
import 'package:conectraponto/services/ml_service.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final MLService _mlService = locator<MLService>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      // final email = _emailController.text.trim();
      // final senha = _senhaController.text;

      final email = '123@123.com';
      final senha = "123123";

      if (email == '123@123.com' && senha == '123123') {
        DatabaseHelper databaseHelper = DatabaseHelper.instance;
        // List predictedData = _mlService.predictedData;
        User userToSave = User(
            user: 'user', password: '123123', nome: "asdasd", email: "asdas");
        databaseHelper.insert(userToSave);
        _mlService.setPredictedData([]);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login bem-sucedido!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email ou senha inválidos.')),
        );
      }
    }
  }

  void _cadastrar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tela de cadastro em construção.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                'Bem-vindo de volta!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Faça login para continuar',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      label: 'E-mail',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'Informe o e-mail';
                        // }
                        // if (!value.contains('@')) {
                        //   return 'E-mail inválido';
                        // }
                        // return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _senhaController,
                      label: 'Senha',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (value) {
                        // if (value == null || value.isEmpty) {
                        //   return 'Informe a senha';
                        // }
                        // if (value.length < 6) {
                        //   return 'Senha muito curta';
                        // }
                        // return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Entrar',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _cadastrar,
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
