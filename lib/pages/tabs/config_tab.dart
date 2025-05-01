import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';

class ConfiguracoesTab extends StatelessWidget {
  const ConfiguracoesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final usuario = userProvider.user;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Configurações",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          Text("Nome: ${usuario?.nome ?? 'Não disponível'}"),
          Text("Email: ${usuario?.email ?? 'Não disponível'}"),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => userProvider.logout(),
            child: Text("Sair"),
          )
        ],
      ),
    );
  }
}
