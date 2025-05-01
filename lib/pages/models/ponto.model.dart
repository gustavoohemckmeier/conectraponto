class Ponto {
  final int? id;
  final int userId;
  final String data;
  final String hora;
  final bool enviado;

  Ponto({
    this.id,
    required this.userId,
    required this.data,
    required this.hora,
    required this.enviado,
  });

  factory Ponto.fromMap(Map<String, dynamic> map) {
    return Ponto(
      id: map['id'],
      userId: map['user_id'],
      data: map['data'],
      hora: map['hora'],
      enviado: map['enviado'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'data': data,
      'hora': hora,
      'enviado': enviado ? 1 : 0,
    };
  }
}
