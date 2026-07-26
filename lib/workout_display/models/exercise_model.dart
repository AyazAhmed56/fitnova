class ExerciseModel {
  final String exerciseId;
  final String exerciseName;
  final String exerciseOrder;
  final String exerciseType;

  final String muscleGroup;
  final List<String> secondaryMuscles;

  final bool isCompound;

  final String difficulty;
  final String equipmentRequired;

  final String sets;
  final String reps;
  final String duration;
  final String rest;
  final String tempo;

  final List<String> instructions;
  final List<String> tips;
  final List<String> precautions;
  final List<String> commonMistakes;
  final List<String> substituteExercises;

  ExerciseModel({
    required this.exerciseId,
    required this.exerciseName,
    required this.exerciseOrder,
    required this.exerciseType,
    required this.muscleGroup,
    required this.secondaryMuscles,
    required this.isCompound,
    required this.difficulty,
    required this.equipmentRequired,
    required this.sets,
    required this.reps,
    required this.duration,
    required this.rest,
    required this.tempo,
    required this.instructions,
    required this.tips,
    required this.precautions,
    required this.commonMistakes,
    required this.substituteExercises,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      exerciseId: map["exerciseId"] ?? "",
      exerciseName: map["exerciseName"] ?? "",
      exerciseOrder: map["exerciseOrder"] ?? "",
      exerciseType: map["exerciseType"] ?? "",

      muscleGroup: map["muscleGroup"] ?? "",

      secondaryMuscles: List<String>.from(map["secondaryMuscles"] ?? []),

      isCompound: map["isCompound"] ?? false,

      difficulty: map["difficulty"] ?? "",
      equipmentRequired: map["equipmentRequired"] ?? "",

      sets: map["sets"] ?? "",
      reps: map["reps"] ?? "",
      duration: map["duration"] ?? "",
      rest: map["rest"] ?? "",
      tempo: map["tempo"] ?? "",

      instructions: List<String>.from(map["instructions"] ?? []),

      tips: List<String>.from(map["tips"] ?? []),

      precautions: List<String>.from(map["precautions"] ?? []),

      commonMistakes: List<String>.from(map["commonMistakes"] ?? []),

      substituteExercises: List<String>.from(map["substituteExercises"] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "exerciseId": exerciseId,
      "exerciseName": exerciseName,
      "exerciseOrder": exerciseOrder,
      "exerciseType": exerciseType,
      "muscleGroup": muscleGroup,
      "secondaryMuscles": secondaryMuscles,
      "isCompound": isCompound,
      "difficulty": difficulty,
      "equipmentRequired": equipmentRequired,
      "sets": sets,
      "reps": reps,
      "duration": duration,
      "rest": rest,
      "tempo": tempo,
      "instructions": instructions,
      "tips": tips,
      "precautions": precautions,
      "commonMistakes": commonMistakes,
      "substituteExercises": substituteExercises,
    };
  }

  ExerciseModel copyWith({
    String? exerciseId,
    String? exerciseName,
    String? exerciseOrder,
    String? exerciseType,
    String? muscleGroup,
    List<String>? secondaryMuscles,
    bool? isCompound,
    String? difficulty,
    String? equipmentRequired,
    String? sets,
    String? reps,
    String? duration,
    String? rest,
    String? tempo,
    List<String>? instructions,
    List<String>? tips,
    List<String>? precautions,
    List<String>? commonMistakes,
    List<String>? substituteExercises,
  }) {
    return ExerciseModel(
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      exerciseOrder: exerciseOrder ?? this.exerciseOrder,
      exerciseType: exerciseType ?? this.exerciseType,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      isCompound: isCompound ?? this.isCompound,
      difficulty: difficulty ?? this.difficulty,
      equipmentRequired: equipmentRequired ?? this.equipmentRequired,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      duration: duration ?? this.duration,
      rest: rest ?? this.rest,
      tempo: tempo ?? this.tempo,
      instructions: instructions ?? this.instructions,
      tips: tips ?? this.tips,
      precautions: precautions ?? this.precautions,
      commonMistakes: commonMistakes ?? this.commonMistakes,
      substituteExercises: substituteExercises ?? this.substituteExercises,
    );
  }

  @override
  String toString() {
    return 'ExerciseModel('
        'exerciseName: $exerciseName, '
        'sets: $sets, '
        'reps: $reps'
        ')';
  }
}
