class ActiveSession {
  final String profileId;
  final String sessionId;
  final String excerciseId;

  ActiveSession(
    this.profileId,
    this.sessionId,
    this.excerciseId,
  );

  ActiveSession.fromMap(Map<String, dynamic> map)
      : profileId = map["profile_id"],
        sessionId = map["session_id"],
        excerciseId = map["excercise_id"];
}
