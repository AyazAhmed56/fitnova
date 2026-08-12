import 'dart:ui';

import 'package:fitnova/workout_display/display_screen/workout_day_details.dart';
import 'package:flutter/material.dart';

import '../models/workout_day_model.dart';
import '../models/workout_plan_model.dart';
import '../services/workout_repository.dart';
import '../widget/day_card.dart';

class WeeklyWorkoutPlan extends StatefulWidget {
  const WeeklyWorkoutPlan({super.key});

  @override
  State<WeeklyWorkoutPlan> createState() => _WeeklyWorkoutPlanState();
}

class _WeeklyWorkoutPlanState extends State<WeeklyWorkoutPlan> {
  final WorkoutRepository _repository = WorkoutRepository.instance;

  late Future<WorkoutPlanModel?> _planFuture;

  @override
  void initState() {
    super.initState();
    _planFuture = _repository.getWorkoutPlan();
  }

  Future<void> _refresh() async {
    setState(() {
      _planFuture = _repository.getWorkoutPlan();
    });

    await _planFuture;
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
            "Weekly Workout Plan",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        body: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<WorkoutPlanModel?>(
            future: _planFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final plan = snapshot.data;

              if (plan == null || plan.totalDays == 0) {
                return const Center(
                  child: Text(
                    "Workout Plan Not Found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                );
              }

              final List<WorkoutDayModel> days = plan.allDays;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                                      Icons.calendar_month,
                                      color: Colors.white,
                                      size: 42,
                                    ),

                                    SizedBox(width: 1),

                                    Text(
                                      "Your Workout Schedule",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: sw * .060,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 8),

                                Center(
                                  child: Text(
                                    "${plan.totalDays} Day Weekly Plan",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: sw * .040,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                Row(
                                  children: [
                                    Expanded(
                                      child: _HeaderCard(
                                        icon: Icons.event,
                                        title: "Days",
                                        value: "${plan.totalDays}",
                                      ),
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: _HeaderCard(
                                        icon: Icons.fitness_center,
                                        title: "Exercises",
                                        value:
                                            "${days.where((e) => !e.restDay).fold<int>(0, (sum, day) => sum + day.workout.length)}",
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
                        "Weekly Schedule",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: sw * .050,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _InfoCard(
                                  icon: Icons.local_fire_department,
                                  title: "Warm Ups",
                                  value:
                                      "${days.fold<int>(0, (sum, day) => sum + day.warmUp.length)}",
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: _InfoCard(
                                  icon: Icons.self_improvement,
                                  title: "Cool Downs",
                                  value:
                                      "${days.fold<int>(0, (sum, day) => sum + day.coolDown.length)}",
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: _InfoCard(
                                  icon: Icons.lightbulb_outline,
                                  title: "Tips",
                                  value:
                                      "${days.fold<int>(0, (sum, day) => sum + day.dailyTips.length)}",
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: _InfoCard(
                                  icon: Icons.self_improvement,
                                  title: "Stretching",
                                  value:
                                      "${days.fold<int>(0, (sum, day) => sum + day.stretching.length)}",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final day = days[index];

                        return DayCard(
                          day: day,
                          isToday: index == 0,
                          isCompleted: false,
                          onTap: () {
                            // Navigate to WorkoutDayDetails
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    WorkoutDayDetails(workoutDay: day),
                              ),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    SizedBox(height: sh * .04),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _HeaderCard({
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(.30),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color.fromARGB(255, 2, 252, 10)),
              SizedBox(width: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ),

          const SizedBox(height: 6),

          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade200,
            ),
          ),
        ],
      ),
    );
  }
}
