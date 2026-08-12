import 'package:fitnova/models/user_profile_model.dart';
import 'package:fitnova/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyGoalsScreen extends StatefulWidget {
  const MyGoalsScreen({super.key});

  @override
  State<MyGoalsScreen> createState() => _MyGoalsScreenState();
}

class _MyGoalsScreenState extends State<MyGoalsScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = true;
  bool isSaving = false;

  UserProfileModel? profile;

  String goal = "";

  String activityLevel = "";

  String bodyGoal = "";

  String fitnessLevel = "";

  int workoutDays = 3;

  // Lose Weight
  final targetWeightController = TextEditingController();
  final durationController = TextEditingController();

  // Build Muscle
  String muscleGainTarget = "";

  // Strength & Power
  String strengthGoal = "";
  String primaryLift = "";
  String repRange = "";

  // Improve Endurance
  String enduranceGoal = "";
  String cardioPreference = "";

  // General Fitness
  List<String> fitnessGoals = [];
  String workoutPlace = "";

  // Athletic Performance
  final sportNameController = TextEditingController();
  List<String> performanceGoals = [];
  String competitionLevel = "";

  final enduranceGoals = [
    "Run Longer",
    "Improve Stamina",
    "Cycling",
    "Swimming",
    "General Cardio",
  ];

  final cardioPreferences = [
    "Running",
    "Cycling",
    "Walking",
    "Swimming",
    "Rowing",
    "HIIT",
    "Jump Rope",
  ];

  final workoutPlaces = ["Gym", "Home", "Outdoor"];

  final generalFitnessGoals = [
    "Improve Mobility",
    "Increase Flexibility",
    "Improve Balance",
    "Core Strength",
    "Stay Active",
    "Posture Improvement",
  ];

  final athleticGoals = [
    "Increase Speed",
    "Increase Agility",
    "Increase Power",
    "Improve Endurance",
    "Improve Coordination",
    "Injury Prevention",
  ];

  final competitionLevels = [
    "Beginner",
    "School",
    "District",
    "State",
    "National",
    "International",
  ];

  final strengthGoals = [
    "Increase Overall Strength",
    "Powerlifting",
    "Olympic Lifting",
    "Explosive Power",
  ];

  final primaryLifts = ["Bench Press", "Squat", "Deadlift", "Overhead Press"];

  final repRanges = ["1-3", "3-5", "5-8"];

  final muscleTargets = [
    "Lean Muscle",
    "Muscle Size (Hypertrophy)",
    "Bulk",
    "Athletic Muscle",
  ];

  final goals = [
    "Lose Weight",
    "Build Muscle",
    "Strength & Power",
    "Improve Endurance",
    "General Fitness",
    "Athletic Performance",
    "Weight Gain"
  ];

  final activities = [
    "Sedentary",
    "Lightly Active",
    "Moderately Active",
    "Very Active",
    "Extra Active",
  ];

  final maleBodyGoals = [
    {"title": "Lean Bulk", "image": "assets/bodygoal/male/lean_bulk.png"},
    {"title": "Clean Bulk", "image": "assets/bodygoal/male/clean_bulk.png"},
    {"title": "Muscle Gain", "image": "assets/bodygoal/male/muscle_gain.png"},
    {"title": "Fat Loss", "image": "assets/bodygoal/male/fat_loss.png"},
    {
      "title": "Body Recomposition",
      "image": "assets/bodygoal/male/body_recomp.png",
    },
    {"title": "Cutting", "image": "assets/bodygoal/male/cutting.png"},
    {"title": "Maintain", "image": "assets/bodygoal/male/maintain.png"},
    {
      "title": "Aesthetic Physique",
      "image": "assets/bodygoal/male/aesthetic_physique.png",
    },
  ];

  final femaleBodyGoals = [
    {"title": "Hour Glass", "image": "assets/bodygoal/female/hour_glass.png"},
    {
      "title": "Lean & Toned",
      "image": "assets/bodygoal/female/lean_&_toned.png",
    },
    {"title": "Muscle Tone", "image": "assets/bodygoal/female/muscle_tone.png"},
    {"title": "Slim Fit", "image": "assets/bodygoal/female/slim_fit.png"},
    {
      "title": "Toned Curves",
      "image": "assets/bodygoal/female/toned_curves.png",
    },
    {"title": "Weight Loss", "image": "assets/bodygoal/female/weight_loss.png"},
    {"title": "Maintain", "image": "assets/bodygoal/female/maintain.png"},
    {
      "title": "Overall Wellness",
      "image": "assets/bodygoal/female/overall_wellness.png",
    },
  ];

  final fitnessLevels = ["Beginner", "Intermediate", "Advanced"];
  @override
  void initState() {
    super.initState();
    loadGoalData();
  }

  Future<void> loadGoalData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final data = await SupabaseService().getUserProfile(user.id);

    if (data != null) {
      profile = data;

      goal = data.goal;

      activityLevel = data.activityLevel;

      bodyGoal = data.bodyGoal;

      fitnessLevel = data.fitnessLevel;

      workoutDays = data.workoutDays;

      targetWeightController.text = data.targetWeight.toString();

      durationController.text = data.durationMonths.toString();

      muscleGainTarget = data.muscleGainTarget;

      strengthGoal = data.strengthGoal;

      primaryLift = data.primaryLift;

      repRange = data.repRange;

      enduranceGoal = data.enduranceGoal;

      cardioPreference = data.cardioPreference;

      fitnessGoals = List.from(data.fitnessGoals);

      workoutPlace = data.workoutPlace;

      sportNameController.text = data.sportName;

      performanceGoals = List.from(data.performanceGoals);

      competitionLevel = data.competitionLevel;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateGoal() async {
    setState(() {
      isSaving = true;
    });

    final updated = UserProfileModel(
      uid: profile!.uid,
      fullName: profile!.fullName,
      age: profile!.age,
      gender: profile!.gender,
      height: profile!.height,
      weight: profile!.weight,
      phone: profile!.phone,
      goal: goal,
      targetWeight: goal == "Lose Weight"
          ? double.tryParse(targetWeightController.text) ?? 0
          : profile!.targetWeight,

      durationMonths: goal == "Lose Weight"
          ? double.tryParse(durationController.text) ?? 0
          : profile!.durationMonths,

      muscleGainTarget: goal == "Build Muscle"
          ? muscleGainTarget
          : profile!.muscleGainTarget,
      strengthGoal: goal == "Strength & Power"
          ? strengthGoal
          : profile!.strengthGoal,

      primaryLift: goal == "Strength & Power"
          ? primaryLift
          : profile!.primaryLift,

      repRange: goal == "Strength & Power" ? repRange : profile!.repRange,
      enduranceGoal: goal == "Improve Endurance"
          ? enduranceGoal
          : profile!.enduranceGoal,

      cardioPreference: goal == "Improve Endurance"
          ? cardioPreference
          : profile!.cardioPreference,

      fitnessGoals: goal == "General Fitness"
          ? fitnessGoals
          : profile!.fitnessGoals,

      workoutPlace: goal == "General Fitness"
          ? workoutPlace
          : profile!.workoutPlace,

      sportName: goal == "Athletic Performance"
          ? sportNameController.text.trim()
          : profile!.sportName,

      performanceGoals: goal == "Athletic Performance"
          ? performanceGoals
          : profile!.performanceGoals,

      competitionLevel: goal == "Athletic Performance"
          ? competitionLevel
          : profile!.competitionLevel,
      workoutDays: workoutDays.clamp(1, 7),
      activityLevel: activityLevel,
      dietaryPreferences: profile!.dietaryPreferences,
      allergies: profile!.allergies,
      comments: profile!.comments,
      mealsPerDay: profile!.mealsPerDay,
      sleepHours: profile!.sleepHours,
      waterIntake: profile!.waterIntake,
      officeTime: profile!.officeTime,
      breakTime: profile!.breakTime,
      job: profile!.job,
      workoutTime: profile!.workoutTime,
      exercise: profile!.exercise,
      wakeUp: profile!.wakeUp,
      budget: profile!.budget,
      workoutPrefer: profile!.workoutPrefer,
      equipmentPrefer: profile!.equipmentPrefer,
      split: profile!.split,
      skinTone: profile!.skinTone,
      skinConcerns: profile!.skinConcerns,
      hairType: profile!.hairType,
      hairConcerns: profile!.hairConcerns,
      scalpType: profile!.scalpType,
      bodyType: profile!.bodyType,
      bodyGoal: bodyGoal,
      fitnessLevel: fitnessLevel,
    );

    await SupabaseService().updateUserProfile(updated);
    await SupabaseService().generateAndSavePlans(updated.uid);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Goal updated successfully. Your new diet and workout plans have been generated.",
          ),
        ),
      );

      Navigator.pop(context);
    }

    if (mounted) {
      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    targetWeightController.dispose();

    durationController.dispose();

    sportNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Goals"), centerTitle: true),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final sw = constraints.maxWidth;
            final sh = constraints.maxHeight;

            return Form(
              key: _formKey,

              child: SingleChildScrollView(
                padding: EdgeInsets.all(sw * .05),

                child: Column(
                  children: [
                    buildGoalDropdown(sw),

                    SizedBox(height: sh * .02),

                    buildWorkoutDays(sw),

                    SizedBox(height: sh * .02),

                    buildActivityDropdown(sw),

                    SizedBox(height: sh * .02),

                    buildBodyGoalDropdown(sw),

                    SizedBox(height: sh * .02),

                    buildFitnessLevelDropdown(sw),

                    SizedBox(height: sh * .03),

                    buildGoalSpecificSection(sw, sh),

                    SizedBox(height: sh * .04),

                    buildUpdateButton(sw, sh),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildGoalDropdown(double sw) {
    return DropdownButtonFormField(
      value: goal,

      decoration: InputDecoration(
        labelText: "Goal",

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sw * .03),
        ),
      ),

      items: goals.map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),

      onChanged: (value) {
        setState(() {
          goal = value!;

          targetWeightController.clear();
          durationController.clear();

          muscleGainTarget = "";

          strengthGoal = "";
          primaryLift = "";
          repRange = "";

          enduranceGoal = "";
          cardioPreference = "";

          fitnessGoals.clear();
          workoutPlace = "";

          sportNameController.clear();
          performanceGoals.clear();
          competitionLevel = "";
        });
      },
    );
  }

  Widget buildWorkoutDays(double sw) {
    return DropdownButtonFormField<int>(
      value: workoutDays,

      decoration: InputDecoration(
        labelText: "Workout Days",

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sw * .03),
        ),
      ),

      items: List.generate(
        7,

        (index) => DropdownMenuItem(
          value: index + 1,

          child: Text("${index + 1} Days"),
        ),
      ),

      onChanged: (value) {
        setState(() {
          workoutDays = value!;
        });
      },
    );
  }

  Widget buildActivityDropdown(double sw) {
    return DropdownButtonFormField(
      value: activityLevel,

      decoration: InputDecoration(
        labelText: "Activity Level",

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sw * .03),
        ),
      ),

      items: activities.map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),

      onChanged: (value) {
        setState(() {
          activityLevel = value!;
        });
      },
    );
  }

  Widget buildBodyGoalDropdown(double sw) {
    final bodyGoalList = profile!.gender.toLowerCase() == "female"
        ? femaleBodyGoals
        : maleBodyGoals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Body Goal",
          style: TextStyle(fontSize: sw * .042, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: bodyGoalList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: .9,
          ),
          itemBuilder: (context, index) {
            final item = bodyGoalList[index];

            final selected = bodyGoal == item["title"];

            return GestureDetector(
              onTap: () {
                setState(() {
                  bodyGoal = item["title"]!;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: selected
                      ? Theme.of(context).colorScheme.primary.withOpacity(.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    width: selected ? 2.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(item["image"]!, fit: BoxFit.contain),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        item["title"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: sw * .035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget buildFitnessLevelDropdown(double sw) {
    return DropdownButtonFormField(
      value: fitnessLevel,

      decoration: InputDecoration(
        labelText: "Fitness Experience",

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sw * .03),
        ),
      ),

      items: fitnessLevels.map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),

      onChanged: (value) {
        setState(() {
          fitnessLevel = value!;
        });
      },
    );
  }

  Widget buildGoalSpecificSection(double sw, double sh) {
    switch (goal) {
      case "Lose Weight":
        return buildLoseWeightSection(sw, sh);

      case "Build Muscle":
        return buildBuildMuscleSection(sw, sh);

      case "Strength & Power":
        return buildStrengthSection(sw, sh);

      case "Improve Endurance":
        return buildEnduranceSection(sw, sh);

      case "General Fitness":
        return buildGeneralFitnessSection(sw, sh);

      case "Athletic Performance":
        return buildAthleticSection(sw, sh);

      default:
        return const SizedBox();
    }
  }

  Widget buildUpdateButton(double sw, double sh) {
    return SizedBox(
      width: double.infinity,

      height: sh * .065,

      child: ElevatedButton(
        onPressed: isSaving
            ? null
            : () {
                if (_formKey.currentState!.validate()) {
                  updateGoal();
                }
              },
        child: isSaving
            ? const CircularProgressIndicator()
            : const Text("Update Goal"),
      ),
    );
  }

  Widget buildLoseWeightSection(double sw, double sh) {
    return Column(
      children: [
        TextFormField(
          controller: targetWeightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: "Target Weight (kg)",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sw * .03),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter target weight";
            }
            return null;
          },
        ),

        SizedBox(height: sh * .02),

        TextFormField(
          controller: durationController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Target Duration (Months)",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sw * .03),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Enter duration";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildBuildMuscleSection(double sw, double sh) {
    return DropdownButtonFormField<String>(
      value: muscleGainTarget.isEmpty ? null : muscleGainTarget,

      decoration: InputDecoration(
        labelText: "Muscle Gain Target",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(sw * .03),
        ),
      ),

      items: muscleTargets.map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),

      onChanged: (value) {
        setState(() {
          muscleGainTarget = value!;
        });
      },
    );
  }

  Widget buildStrengthSection(double sw, double sh) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: strengthGoal.isEmpty ? null : strengthGoal,

          decoration: InputDecoration(
            labelText: "Strength Goal",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sw * .03),
            ),
          ),

          items: strengthGoals.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),

          onChanged: (value) {
            setState(() {
              strengthGoal = value!;
            });
          },
        ),

        SizedBox(height: sh * .02),

        DropdownButtonFormField<String>(
          value: primaryLift.isEmpty ? null : primaryLift,

          decoration: InputDecoration(
            labelText: "Primary Lift",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sw * .03),
            ),
          ),

          items: primaryLifts.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),

          onChanged: (value) {
            setState(() {
              primaryLift = value!;
            });
          },
        ),

        SizedBox(height: sh * .02),

        DropdownButtonFormField<String>(
          value: repRange.isEmpty ? null : repRange,

          decoration: InputDecoration(
            labelText: "Preferred Rep Range",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sw * .03),
            ),
          ),

          items: repRanges.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),

          onChanged: (value) {
            setState(() {
              repRange = value!;
            });
          },
        ),
      ],
    );
  }

  Widget buildEnduranceSection(double sw, double sh) {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: enduranceGoal.isEmpty ? null : enduranceGoal,

          decoration: InputDecoration(
            labelText: "Endurance Goal",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sw * .03),
            ),
          ),

          items: enduranceGoals.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),

          onChanged: (value) {
            setState(() {
              enduranceGoal = value!;
            });
          },
        ),

        SizedBox(height: sh * .02),

        DropdownButtonFormField<String>(
          value: cardioPreference.isEmpty ? null : cardioPreference,

          decoration: InputDecoration(
            labelText: "Cardio Preference",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sw * .03),
            ),
          ),

          items: cardioPreferences.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),

          onChanged: (value) {
            setState(() {
              cardioPreference = value!;
            });
          },
        ),
      ],
    );
  }

  Widget buildGeneralFitnessSection(double sw, double sh) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Fitness Goals",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: sw * .04),
        ),

        SizedBox(height: sh * .015),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: generalFitnessGoals.map((goalItem) {
            final selected = fitnessGoals.contains(goalItem);

            return FilterChip(
              label: Text(goalItem),
              selected: selected,
              onSelected: (value) {
                setState(() {
                  if (selected) {
                    fitnessGoals.remove(goalItem);
                  } else {
                    fitnessGoals.add(goalItem);
                  }
                });
              },
            );
          }).toList(),
        ),

        SizedBox(height: sh * .03),

        DropdownButtonFormField<String>(
          value: workoutPlace.isEmpty ? null : workoutPlace,

          decoration: InputDecoration(
            labelText: "Workout Place",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sw * .03),
            ),
          ),

          items: workoutPlaces.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),

          onChanged: (value) {
            setState(() {
              workoutPlace = value!;
            });
          },
        ),
      ],
    );
  }

  Widget buildAthleticSection(double sw, double sh) {
    return Column(
      children: [
        TextFormField(
          controller: sportNameController,

          decoration: InputDecoration(
            labelText: "Sport Name",

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sw * .03),
            ),
          ),
        ),

        SizedBox(height: sh * .03),

        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Performance Goals",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: sw * .04),
          ),
        ),

        SizedBox(height: sh * .015),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: athleticGoals.map((goalItem) {
            final selected = performanceGoals.contains(goalItem);

            return FilterChip(
              label: Text(goalItem),

              selected: selected,

              onSelected: (value) {
                setState(() {
                  if (selected) {
                    performanceGoals.remove(goalItem);
                  } else {
                    performanceGoals.add(goalItem);
                  }
                });
              },
            );
          }).toList(),
        ),

        SizedBox(height: sh * .03),

        DropdownButtonFormField<String>(
          value: competitionLevel.isEmpty ? null : competitionLevel,

          decoration: InputDecoration(
            labelText: "Competition Level",

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(sw * .03),
            ),
          ),

          items: competitionLevels.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),

          onChanged: (value) {
            setState(() {
              competitionLevel = value!;
            });
          },
        ),
      ],
    );
  }
}
