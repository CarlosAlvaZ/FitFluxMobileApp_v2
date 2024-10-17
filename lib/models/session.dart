class Session {
  final String id;
  final String profileId;
  final int day;
  final int excerciseCount;

  Session(this.id, this.profileId, this.excerciseCount, this.day);

  Session.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        profileId = map['profile_id'],
        day = map['day'],
        excerciseCount = map['excercise_count'];
}
