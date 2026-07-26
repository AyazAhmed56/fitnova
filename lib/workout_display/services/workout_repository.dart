import '../models/workout_day_model.dart';
import '../models/workout_plan_model.dart';
import 'workout_supabase_service.dart';

class WorkoutRepository {
  WorkoutRepository._();

  static final WorkoutRepository instance = WorkoutRepository._();

  final WorkoutSupabaseService _service = WorkoutSupabaseService.instance;

  ///--------------------------------------------------------------
  /// Entire Workout Plan
  ///--------------------------------------------------------------

  Future<WorkoutPlanModel?> getWorkoutPlan() {
    return _service.getWorkoutPlan();
  }

  Stream<WorkoutPlanModel?> workoutStream() {
    return _service.workoutStream();
  }

  Future<void> saveWorkoutPlan(WorkoutPlanModel plan) {
    return _service.saveWorkoutPlan(plan);
  }

  Future<void> updateWorkoutPlan(WorkoutPlanModel plan) {
    return _service.updateWorkoutPlan(plan);
  }

  Future<void> deleteWorkoutPlan() {
    return _service.deleteWorkoutPlan();
  }

  Future<bool> hasWorkoutPlan() {
    return _service.hasWorkoutPlan();
  }

  ///--------------------------------------------------------------
  /// Day Helpers
  ///--------------------------------------------------------------

  Future<WorkoutDayModel?> getWorkoutDay(String dayKey) async {
    final plan = await getWorkoutPlan();

    if (plan == null) {
      return null;
    }

    return plan.getDay(dayKey);
  }

  Future<List<WorkoutDayModel>> getAllWorkoutDays() async {
    final plan = await getWorkoutPlan();

    if (plan == null) {
      return [];
    }

    return plan.allDays;
  }
}
