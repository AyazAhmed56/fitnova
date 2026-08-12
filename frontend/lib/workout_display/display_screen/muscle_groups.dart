import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/exercise_model.dart';
import '../models/workout_day_model.dart';
import '../widget/muscle_chip.dart';

class MuscleGroupsScreen extends StatelessWidget {
  final WorkoutDayModel workoutDay;

  const MuscleGroupsScreen({super.key, required this.workoutDay});

  List<String> get primaryMuscles {
    final muscles = <String>{};

    for (ExerciseModel exercise in workoutDay.workout) {
      if (exercise.muscleGroup.trim().isNotEmpty) {
        muscles.add(exercise.muscleGroup.trim());
      }
    }

    return muscles.toList()..sort();
  }

  List<String> get secondaryMuscles {
    final muscles = <String>{};

    for (ExerciseModel exercise in workoutDay.workout) {
      muscles.addAll(exercise.secondaryMuscles);
    }

    return muscles.toSet().toList()..sort();
  }

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
          title: const Text(
            "Muscle Groups",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: sh * .03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),

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
                          Row(
                            children: [
                              Icon(
                                Icons.accessibility_new,
                                color: Colors.white,
                                size: 42,
                              ),

                              SizedBox(width: 16),

                              Text(
                                workoutDay.dayName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: sw * .060,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          Text(
                            workoutDay.focus,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: sw * .040,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: _TopCard(
                                  icon: Icons.fitness_center,
                                  title: "Exercises",
                                  value: "${workoutDay.workout.length}",
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _TopCard(
                                  icon: Icons.accessibility,
                                  title: "Primary",
                                  value: "${primaryMuscles.length}",
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: _TopCard(
                                  icon: Icons.groups,
                                  title: "Secondary",
                                  value: "${secondaryMuscles.length}",
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
                  "Primary Muscle Groups",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sw * .050,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: primaryMuscles
                      .map((muscle) => MuscleChip(muscle: muscle))
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  "Secondary Muscle Groups",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: sw * .050,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              if (secondaryMuscles.isEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      "No Secondary Muscles",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: secondaryMuscles
                        .map((muscle) => MuscleChip(muscle: muscle))
                        .toList(),
                  ),
                ),

              const SizedBox(height: 20),

              Container(
                // margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.analytics_outlined, color: Colors.white),

                        const SizedBox(width: 10),

                        Text(
                          "Workout Distribution",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: sw * .046,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    ...workoutDay.workout.map(
                      (exercise) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          width: double.infinity,
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
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
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
                                      exercise.exerciseName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    MuscleChip(muscle: exercise.muscleGroup),

                                    if (exercise
                                        .secondaryMuscles
                                        .isNotEmpty) ...[
                                      const SizedBox(height: 12),

                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: exercise.secondaryMuscles
                                            .map(
                                              (muscle) =>
                                                  MuscleChip(muscle: muscle),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: sh * .04),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _TopCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
