class Protocols {
  final int id;
  final String name;
  final int amplitude;
  final int time;
  final String type;
  final int percentageUP;
  final int percentageDOWN;

  const Protocols({
    required this.id,
    required this.name,
    required this.amplitude,
    required this.time,
    required this.type,
    required this.percentageUP,
    required this.percentageDOWN,
  });

  factory Protocols.fromSqfliteDatabase(Map<String, dynamic> map) => Protocols(
      id: map['id']?.toInt() ?? 0,
      name: map['Nome'] ?? '',
      amplitude: map['Amplitude'] ?? 1,
      time: map['Tempo'] ?? 1,
      type: map['Tipo'] ?? '',
      percentageUP: map['Porcentagem Incremento'] ?? 1,
      percentageDOWN: map['Porcentagem Decremento'] ?? 1);
}
