import 'cooldown_model.dart';
import 'exercise_model.dart';
import 'warmup_model.dart';
import 'stretching_model.dart';

class WorkoutDayModel {
  final String dayName;
  final String focus;
  final String difficulty;
  final String estimatedDuration;

  final String motivation;
  final String notes;

  final bool restDay;
  final String activity;
  final List<String> recoveryTips;

  final List<String> dailyTips;
  final List<String> precautions;

  final List<WarmupModel> warmUp;
  final List<ExerciseModel> workout;
  final List<StretchingModel> stretching;
  final List<CooldownModel> coolDown;

  WorkoutDayModel({
    required this.dayName,
    required this.focus,
    required this.difficulty,
    required this.estimatedDuration,
    required this.motivation,
    required this.notes,
    required this.restDay,
    required this.activity,
    required this.recoveryTips,
    required this.dailyTips,
    required this.precautions,
    required this.warmUp,
    required this.workout,
    required this.stretching,
    required this.coolDown,
  });

  factory WorkoutDayModel.fromMap(Map<String, dynamic> map) {
    return WorkoutDayModel(
      dayName: map["dayName"] ?? "",

      focus: map["focus"] ?? "",

      difficulty: map["difficulty"] ?? "",

      estimatedDuration: map["estimatedDuration"] ?? "",

      motivation: map["motivation"] ?? "",

      notes: map["notes"] ?? "",

      restDay: map["restDay"] ?? false,

      activity: map["activity"] ?? "",

      recoveryTips: List<String>.from(map["recoveryTips"] ?? []),

      dailyTips: List<String>.from(map["dailyTips"] ?? []),

      precautions: List<String>.from(map["precautions"] ?? []),

      warmUp: (map["warmUp"] as List<dynamic>? ?? [])
          .map((e) => WarmupModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),

      workout: (map["workout"] as List<dynamic>? ?? [])
          .map((e) => ExerciseModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),

      stretching: (map["stretching"] as List<dynamic>? ?? [])
          .map((e) => StretchingModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),

      coolDown: (map["coolDown"] as List<dynamic>? ?? [])
          .map((e) => CooldownModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "dayName": dayName,
      "focus": focus,
      "difficulty": difficulty,
      "estimatedDuration": estimatedDuration,
      "motivation": motivation,
      "notes": notes,
      "restDay": restDay,
      "activity": activity,
      "recoveryTips": recoveryTips,
      "dailyTips": dailyTips,
      "precautions": precautions,
      "warmUp": warmUp.map((e) => e.toMap()).toList(),
      "workout": workout.map((e) => e.toMap()).toList(),
      "stretching": stretching.map((e) => e.toMap()).toList(),
      "coolDown": coolDown.map((e) => e.toMap()).toList(),
    };
  }

  WorkoutDayModel copyWith({
    String? dayName,
    String? focus,
    String? difficulty,
    String? estimatedDuration,
    String? motivation,
    String? notes,
    bool? restDay,
    String? activity,
    List<String>? recoveryTips,
    List<String>? dailyTips,
    List<String>? precautions,
    List<WarmupModel>? warmUp,
    List<ExerciseModel>? workout,
    List<StretchingModel>? stretching,
    List<CooldownModel>? coolDown,
  }) {
    return WorkoutDayModel(
      dayName: dayName ?? this.dayName,
      focus: focus ?? this.focus,
      difficulty: difficulty ?? this.difficulty,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      motivation: motivation ?? this.motivation,
      notes: notes ?? this.notes,
      restDay: restDay ?? this.restDay,
      activity: activity ?? this.activity,
      recoveryTips: recoveryTips ?? this.recoveryTips,
      dailyTips: dailyTips ?? this.dailyTips,
      precautions: precautions ?? this.precautions,
      warmUp: warmUp ?? this.warmUp,
      workout: workout ?? this.workout,
      stretching: stretching ?? this.stretching,
      coolDown: coolDown ?? this.coolDown,
    );
  }

  @override
  String toString() {
    return '''
WorkoutDayModel(
  dayName: $dayName,
  focus: $focus,
  difficulty: $difficulty,
  duration: $estimatedDuration,
  warmUp: ${warmUp.length},
  workout: ${workout.length},
  stretching: ${stretching.length},
  coolDown: ${coolDown.length},
  restDay: $restDay,
  activity: $activity,
  recoveryTips: ${recoveryTips.length},
)
''';
  }
}
