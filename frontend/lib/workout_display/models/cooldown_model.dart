class CooldownModel {
  final String exerciseId;
  final String exerciseName;
  final String duration;

  final List<String> instructions;

  CooldownModel({
    required this.exerciseId,
    required this.exerciseName,
    required this.duration,
    required this.instructions,
  });

  factory CooldownModel.fromMap(Map<String, dynamic> map) {
    return CooldownModel(
      exerciseId: map["exerciseId"] ?? "",
      exerciseName: map["exerciseName"] ?? "",
      duration: map["duration"] ?? "",
      instructions: List<String>.from(map["instructions"] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "exerciseId": exerciseId,
      "exerciseName": exerciseName,
      "duration": duration,
      "instructions": instructions,
    };
  }

  CooldownModel copyWith({
    String? exerciseId,
    String? exerciseName,
    String? duration,
    List<String>? instructions,
  }) {
    return CooldownModel(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  String toString() {
    return 'CooldownModel('
        'exerciseName: $exerciseName, '
        'duration: $duration'
        ')';
  }
}
