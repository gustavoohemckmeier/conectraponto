import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/ponto_provider.dart';
import '../models/ponto.model.dart';

class RecibosTab extends StatelessWidget {
  const RecibosTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pontoProvider = Provider.of<PontoProvider>(context);
    final pontos = [];

    return ListView.builder(
      itemCount: pontos.length,
      itemBuilder: (context, index) {
        final ponto = pontos[index];
        return ListTile(
          title: Text("Registrado às ${ponto.hora}"),
          subtitle: Text("Data: ${ponto.data}"),
        );
      },
    );
  }
}
