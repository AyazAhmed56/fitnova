import 'dart:ui';

import 'package:fitnova/workout_display/display_screen/cooldown_screen.dart';
import 'package:fitnova/workout_display/display_screen/daily_tips.dart';
import 'package:fitnova/workout_display/display_screen/equipment_library.dart';
import 'package:fitnova/workout_display/display_screen/exercise_library.dart';
import 'package:fitnova/workout_display/display_screen/muscle_groups.dart';
import 'package:fitnova/workout_display/display_screen/warmup_screen.dart';
import 'package:fitnova/workout_display/display_screen/workout_precautions.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import '../models/workout_day_model.dart';
import 'package:fitnova/workout_display/display_screen/stretching_screen.dart';

class WorkoutDayDetails extends StatelessWidget {
  final WorkoutDayModel workoutDay;

  const WorkoutDayDetails({super.key, required this.workoutDay});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/workout_background.png'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(0.9),
            BlendMode.modulate,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(
            workoutDay.dayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: sh * .03, top: sh * .03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!workoutDay.restDay) ...[
                SizedBox(
                  height: 32,
                  child: Marquee(
                    text: workoutDay.motivation,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 20.0,
                    velocity: 50.0,
                    pauseAfterRound: Duration(seconds: 1),
                    startPadding: 10.0,
                    accelerationDuration: Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                  ),
                ),
              ],

              SizedBox(height: 18),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            workoutDay.dayName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: sw * .060,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Text(
                            workoutDay.restDay
                                ? workoutDay.activity
                                : workoutDay.focus,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: sw * .040,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Row(
                            children: [
                              Expanded(
                                child: _QuickInfoCard(
                                  icon: workoutDay.restDay
                                      ? Icons.self_improvement
                                      : Icons.schedule,
                                  title: workoutDay.restDay
                                      ? "Activity"
                                      : "Duration",
                                  value: workoutDay.restDay
                                      ? workoutDay.activity
                                      : workoutDay.estimatedDuration,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _QuickInfoCard(
                                  icon: workoutDay.restDay
                                      ? Icons.favorite
                                      : Icons.bar_chart,
                                  title: workoutDay.restDay
                                      ? "Recovery"
                                      : "Difficulty",
                                  value: workoutDay.restDay
                                      ? "Recovery Day"
                                      : workoutDay.difficulty,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  workoutDay.restDay ? "Recovery Plan" : "Today's Workout",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sw * .050,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.50),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    if (!workoutDay.restDay) ...[
                      WorkoutOptionTile(
                        icon: Icons.local_fire_department,
                        title: "Warm Up",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  WarmupScreen(workoutDay: workoutDay),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1, indent: 20, endIndent: 20),

                      WorkoutOptionTile(
                        icon: Icons.fitness_center,
                        title: "Workout Exercises",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ExerciseLibraryScreen(workoutDay: workoutDay),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1, indent: 20, endIndent: 20),
                    ],

                    WorkoutOptionTile(
                      icon: Icons.self_improvement,
                      title: "Stretching",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                StretchingScreen(workoutDay: workoutDay),
                          ),
                        );
                      },
                    ),

                    if (!workoutDay.restDay) ...[
                      const Divider(height: 1, indent: 20, endIndent: 20),

                      WorkoutOptionTile(
                        icon: Icons.accessibility,
                        title: "Cool Down",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CooldownScreen(workoutDay: workoutDay),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Workout Resources",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sw * .050,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.15),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    WorkoutOptionTile(
                      icon: Icons.lightbulb_outline,
                      title: "Daily Tips",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DailyTipsScreen(workoutDay: workoutDay),
                          ),
                        );
                      },
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    WorkoutOptionTile(
                      icon: Icons.warning_amber_rounded,
                      title: workoutDay.restDay
                          ? "Recovery Tips"
                          : "Precautions",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => WorkoutPrecautionsScreen(
                              workoutDay: workoutDay,
                            ),
                          ),
                        );
                      },
                    ),

                    if (!workoutDay.restDay) ...[
                      const Divider(height: 1, indent: 20, endIndent: 20),

                      WorkoutOptionTile(
                        icon: Icons.handyman_outlined,
                        title: "Equipment",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EquipmentLibraryScreen(
                                workoutDay: workoutDay,
                              ),
                            ),
                          );
                        },
                      ),

                      const Divider(height: 1, indent: 20, endIndent: 20),

                      WorkoutOptionTile(
                        icon: Icons.accessibility_new,
                        title: "Targeted Muscle Groups",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MuscleGroupsScreen(workoutDay: workoutDay),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              if (workoutDay.notes.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.blue),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Coach Notes",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              workoutDay.notes,
                              style: const TextStyle(
                                height: 1.6,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: sh * .04),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _QuickInfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color.fromARGB(255, 2, 253, 10)),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            value.isEmpty ? "-" : value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkoutOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const WorkoutOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xffEEE7FF),
              child: Icon(icon, size: 18, color: const Color(0xff6D3FD1)),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 8),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.white30,
            ),
          ],
        ),
      ),
    );
  }
}
