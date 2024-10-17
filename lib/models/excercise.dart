class Excercise {
  final String id;
  final String sessionId;
  final String name;
  final String description;
  final bool isFlexible;
  final int order;
  final int duration;

  Excercise(this.id, this.name, this.description, this.isFlexible,
      this.duration, this.sessionId, this.order);

  Excercise.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        sessionId = map['session_id'],
        name = map['name'],
        description = map['description'],
        isFlexible = map['is_flexible'],
        order = map['excercise_order'],
        duration = map['duration'];
}
