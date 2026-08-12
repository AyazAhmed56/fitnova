class StretchingModel {
  final String exerciseId;
  final String exerciseName;
  final String bodyPart;
  final String duration;
  final List<String> instructions;

  const StretchingModel({
    required this.exerciseId,
    required this.exerciseName,
    required this.bodyPart,
    required this.duration,
    required this.instructions,
  });

  factory StretchingModel.fromMap(Map<String, dynamic> map) {
    return StretchingModel(
      exerciseId: map['exerciseId'] ?? '',
      exerciseName: map['exerciseName'] ?? '',
      bodyPart: map['bodyPart'] ?? '',
      duration: map['duration'] ?? '',
      instructions: List<String>.from(map['instructions'] ?? const []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'bodyPart': bodyPart,
      'duration': duration,
      'instructions': instructions,
    };
  }

  StretchingModel copyWith({
    String? exerciseId,
    String? exerciseName,
    String? bodyPart,
    String? duration,
    List<String>? instructions,
  }) {
    return StretchingModel(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      bodyPart: bodyPart ?? this.bodyPart,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
    );
  }
}
