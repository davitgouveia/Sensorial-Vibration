class Protocols {
  final int id;
  final String name;
  final int amplitude;
  final int time;
  final String type;
  final int percentageUP;
  final int percentageDOWN;
  final int reversions;

  const Protocols({
    required this.id,
    required this.name,
    required this.amplitude,
    required this.time,
    required this.type,
    required this.percentageUP,
    required this.percentageDOWN,
    required this.reversions,
  });

  factory Protocols.fromSqfliteDatabase(Map<String, dynamic> map) => Protocols(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? 'null',
      amplitude: map['amplitude'] ?? 128,
      time: map['time'] ?? 1000,
      type: map['type'] ?? 'A',
      percentageUP: map['percentageUP'] ?? 30,
      percentageDOWN: map['percentageDOWN'] ?? 20,
      reversions: map['reversions'] ?? 10);
}
