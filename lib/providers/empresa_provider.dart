import 'package:flutter/material.dart';
import '../pages/models/empresa.model.dart';

class EmpresaProvider with ChangeNotifier {
  Empresa? _empresa;

  Empresa? get empresa => _empresa;

  void setEmpresa(Empresa empresa) {
    _empresa = empresa;
    notifyListeners();
  }

  void limparEmpresa() {
    _empresa = null;
    notifyListeners();
  }
}
