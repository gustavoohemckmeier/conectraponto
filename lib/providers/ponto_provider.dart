import 'package:conectraponto/pages/models/ponto.model.dart';
import 'package:flutter/material.dart';

class PontoProvider with ChangeNotifier {
  Ponto? _ponto;

  Ponto? get ponto => _ponto;

  void setUser(Ponto ponto) {
    _ponto = ponto;
    notifyListeners();
  }

  void logout() {
    _ponto = null;
    notifyListeners();
  }
}
