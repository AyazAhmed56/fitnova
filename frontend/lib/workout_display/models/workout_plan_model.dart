import 'workout_day_model.dart';

class WorkoutPlanModel {
  final Map<String, WorkoutDayModel> days;
  final DateTime createdAt;

  WorkoutPlanModel({required this.days, required this.createdAt});

  factory WorkoutPlanModel.fromMap(Map<String, dynamic> map) {
    final Map<String, WorkoutDayModel> parsedDays = {};

    if (map["days"] != null) {
      final dayMap = Map<String, dynamic>.from(map["days"]);

      dayMap.forEach((key, value) {
        parsedDays[key] = WorkoutDayModel.fromMap(
          Map<String, dynamic>.from(value),
        );
      });
    }

    return WorkoutPlanModel(
      days: parsedDays,
      createdAt: map["createdAt"] != null
          ? DateTime.parse(map["createdAt"])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "createdAt": createdAt.toIso8601String(),
      "days": days.map((key, value) => MapEntry(key, value.toMap())),
    };
  }

  WorkoutPlanModel copyWith({Map<String, WorkoutDayModel>? days}) {
    return WorkoutPlanModel(days: days ?? this.days, createdAt: DateTime.now());
  }

  /// Returns all day keys
  ///
  /// Example:
  /// Day1
  /// Day2
  /// Day3
  List<String> get dayKeys => days.keys.toList();

  /// Returns all workout days
  List<WorkoutDayModel> get allDays => days.values.toList();

  /// Total workout days
  int get totalDays => days.length;

  /// Get a workout day by key
  WorkoutDayModel? getDay(String dayKey) {
    return days[dayKey];
  }

  /// Get day by index
  WorkoutDayModel? getDayAt(int index) {
    if (index < 0 || index >= days.length) {
      return null;
    }

    return allDays[index];
  }

  /// Check if day exists
  bool containsDay(String dayKey) {
    return days.containsKey(dayKey);
  }

  @override
  String toString() {
    return '''
WorkoutPlanModel(
  totalDays: $totalDays,
  days: $dayKeys
)
''';
  }
}
