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
      name: map['Nome'] ?? 'null',
      amplitude: map['Amplitude'] ?? 128,
      time: map['Tempo'] ?? 1000,
      type: map['Tipo'] ?? 'A',
      percentageUP: map['Porcentagem Incremento'] ?? 30,
      percentageDOWN: map['Porcentagem Decremento'] ?? 20);
}
