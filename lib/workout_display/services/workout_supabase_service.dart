import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/workout_plan_model.dart';

class WorkoutSupabaseService {
  WorkoutSupabaseService._();

  static final WorkoutSupabaseService instance = WorkoutSupabaseService._();

  final SupabaseClient _supabase = Supabase.instance.client;

  //==========================================================
  // TABLE
  //==========================================================

  static const String table = 'workout_plans';

  //==========================================================
  // CURRENT USER
  //==========================================================

  String get _uid {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    return user.id;
  }

  //==========================================================
  // SAVE WORKOUT PLAN
  //==========================================================

  Future<void> saveWorkoutPlan(WorkoutPlanModel workoutPlan) async {
    final now = DateTime.now();

    await _supabase.from(table).upsert({
      'user_id': _uid,
      'plan': workoutPlan.toMap(),
      'generated_at': now.toIso8601String(),
      'expires_at': now.add(const Duration(days: 30)).toIso8601String(),
      'is_active': true,
    });
  }

  //==========================================================
  // GET WORKOUT PLAN
  //==========================================================

  Future<WorkoutPlanModel?> getWorkoutPlan() async {
    final response = await _supabase
        .from(table)
        .select('plan')
        .eq('user_id', _uid)
        .order('generated_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    final data = response['plan'];

    if (data == null) {
      return null;
    }

    return WorkoutPlanModel.fromMap(Map<String, dynamic>.from(data));
  }

  //==========================================================
  // CHECK PLAN EXISTS
  //==========================================================

  Future<bool> hasWorkoutPlan() async {
    final response = await _supabase
        .from(table)
        .select('id')
        .eq('user_id', _uid)
        .limit(1)
        .maybeSingle();

    return response != null;
  }
  //==========================================================
  // UPDATE WORKOUT PLAN
  //==========================================================

  Future<void> updateWorkoutPlan(WorkoutPlanModel workoutPlan) async {
    await _supabase
        .from(table)
        .update({
          'plan': workoutPlan.toMap(),
          'generated_at': DateTime.now().toIso8601String(),
          'expires_at': DateTime.now()
              .add(const Duration(days: 30))
              .toIso8601String(),
          'is_active': true,
        })
        .eq('user_id', _uid);
  }

  //==========================================================
  // DELETE WORKOUT PLAN
  //==========================================================

  Future<void> deleteWorkoutPlan() async {
    await _supabase.from(table).delete().eq('user_id', _uid);
  }

  //==========================================================
  // DEACTIVATE WORKOUT PLAN
  //==========================================================

  Future<void> deactivateWorkoutPlan() async {
    await _supabase
        .from(table)
        .update({'is_active': false})
        .eq('user_id', _uid);
  }

  //==========================================================
  // REALTIME STREAM
  //==========================================================

  Stream<WorkoutPlanModel?> workoutStream() {
    return _supabase
        .from(table)
        .stream(primaryKey: ['id'])
        .eq('user_id', _uid)
        .map((rows) {
          if (rows.isEmpty) {
            return null;
          }

          final data = rows.first['plan'];

          if (data == null) {
            return null;
          }

          return WorkoutPlanModel.fromMap(Map<String, dynamic>.from(data));
        });
  }

  //==========================================================
  // REFRESH WORKOUT PLAN
  //==========================================================

  Future<WorkoutPlanModel?> refreshWorkoutPlan() async {
    return await getWorkoutPlan();
  }

  //==========================================================
  // PLAN STATUS
  //==========================================================

  Future<bool> isWorkoutPlanExpired() async {
    final response = await _supabase
        .from(table)
        .select('expires_at')
        .eq('user_id', _uid)
        .order('generated_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      return true;
    }

    final expiresAt = response['expires_at'];

    if (expiresAt == null) {
      return true;
    }

    return DateTime.now().isAfter(DateTime.parse(expiresAt.toString()));
  }

  Future<Duration> remainingTime() async {
    final response = await _supabase
        .from(table)
        .select('expires_at')
        .eq('user_id', _uid)
        .order('generated_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response == null) {
      return Duration.zero;
    }

    final expiresAt = response['expires_at'];

    if (expiresAt == null) {
      return Duration.zero;
    }

    final remaining = DateTime.parse(
      expiresAt.toString(),
    ).difference(DateTime.now());

    return remaining.isNegative ? Duration.zero : remaining;
  }
}
