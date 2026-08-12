import 'package:fitnova/models/user_profile_model.dart';
import 'package:fitnova/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyPlanScreen extends StatefulWidget {
  const MyPlanScreen({super.key});

  @override
  State<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends State<MyPlanScreen> {
  bool isLoading = true;
  bool isSaving = false;

  UserProfileModel? profile;

  //---------------- DAILY ROUTINE ----------------//

  final wakeupController = TextEditingController();
  final officeController = TextEditingController();
  final breakController = TextEditingController();
  final workoutTimeController = TextEditingController();
  final exerciseController = TextEditingController();
  final sleepController = TextEditingController();
  final waterController = TextEditingController();

  //---------------- DIET ----------------//

  final allergiesController = TextEditingController();
  final mealsController = TextEditingController();
  final budgetController = TextEditingController();
  final commentsController = TextEditingController();

  //---------------- DROPDOWNS ----------------//

  String workoutPrefer = '';
  String workoutPlace = '';
  String equipmentPrefer = '';
  String split = '';
  String fitnessLevel = '';

  String skinTone = '';

  String hairType = '';
  String scalpType = '';

  //---------------- CHIPS ----------------//

  List<String> selectedDiet = [];
  List<String> selectedSkinConcerns = [];
  List<String> selectedHairConcerns = [];

  //---------------- OPTIONS ----------------//

  final List<String> dietOptions = [
    'Vegetarian',
    'Vegan',
    'Eggetarian',
    'Non-Vegetarian',
    'Jain',
    'Gluten Free',
    'Dairy Free',
    'Low Carb',
    'Low Fat',
  ];

  final List<String> workoutPreferenceOptions = [
    "Gym",
    "Home",
    "Outdoor",
    "Hybrid",
  ];

  final List<String> workoutPlaceOptions = [
    "Home",
    "Gym",
    "Park",
    "Office Gym",
    "Outdoor",
  ];

  final List<String> equipmentOptions = [
    "No Equipment",
    "Resistance Bands",
    "Dumbbells",
    "Machines",
    "Full Gym",
  ];

  final List<String> splitOptions = [
    "Full Body",
    "Upper / Lower",
    "Push Pull Legs",
    "Bro Split",
    "Custom",
  ];

  final List<String> fitnessOptions = ["Beginner", "Intermediate", "Advanced"];

  final List<String> skinToneOptions = [
    "Fair",
    "Light",
    "Medium",
    "Olive",
    "Brown",
    "Dark",
  ];

  final List<String> skinConcernOptions = [
    "Acne",
    "Tanning",
    "Pigmentation",
    "Dry Skin",
    "Oily Skin",
    "Dark Spots",
    "Dull Skin",
  ];

  final List<String> hairTypeOptions = ["Straight", "Wavy", "Curly", "Coily"];

  final List<String> scalpOptions = [
    "Normal",
    "Dry",
    "Oily",
    "Combination",
    "Sensitive",
  ];

  final List<String> hairConcernOptions = [
    "Hair Fall",
    "Dandruff",
    "Dry Hair",
    "Frizzy Hair",
    "Split Ends",
    "Slow Growth",
    "Thin Hair",
  ];

  @override
  void initState() {
    super.initState();
    loadPlan();
  }

  Future<void> loadPlan() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    profile = await SupabaseService().getUserProfile(user.id);

    if (profile != null) {
      //---------------- DAILY ----------------//

      wakeupController.text = profile!.wakeUp;
      officeController.text = profile!.officeTime;
      breakController.text = profile!.breakTime;
      workoutTimeController.text = profile!.workoutTime;
      exerciseController.text = profile!.exercise;
      sleepController.text = profile!.sleepHours;
      waterController.text = profile!.waterIntake;

      //---------------- DIET ----------------//

      allergiesController.text = profile!.allergies;
      mealsController.text = profile!.mealsPerDay;
      budgetController.text = profile!.budget;
      commentsController.text = profile!.comments;

      //---------------- DROPDOWNS ----------------//

      workoutPrefer = profile!.workoutPrefer;
      workoutPlace = profile!.workoutPlace;
      equipmentPrefer = profile!.equipmentPrefer;
      split = profile!.split;
      fitnessLevel = profile!.fitnessLevel;

      skinTone = profile!.skinTone;

      hairType = profile!.hairType;
      scalpType = profile!.scalpType;

      //---------------- CHIPS ----------------//

      selectedDiet = List.from(profile!.dietaryPreferences);
      selectedSkinConcerns = List.from(profile!.skinConcerns);
      selectedHairConcerns = List.from(profile!.hairConcerns);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    wakeupController.dispose();
    officeController.dispose();
    breakController.dispose();
    workoutTimeController.dispose();
    exerciseController.dispose();
    sleepController.dispose();
    waterController.dispose();

    allergiesController.dispose();
    mealsController.dispose();
    budgetController.dispose();
    commentsController.dispose();

    super.dispose();
  }

  //------------------------------------------------------------//
  //--------------------- HELPER WIDGETS ------------------------//
  //------------------------------------------------------------//

  Widget _sectionTitle(String title, double sw) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(fontSize: sw * .05, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _dropdown(
    String title,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _chipSection({
    required List<String> options,
    required List<String> selectedList,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((item) {
        final selected = selectedList.contains(item);

        return FilterChip(
          label: Text(item),
          selected: selected,
          onSelected: (value) {
            setState(() {
              if (value) {
                selectedList.add(item);
              } else {
                selectedList.remove(item);
              }
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Plan"), centerTitle: true),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final sw = constraints.maxWidth;
            final sh = constraints.maxHeight;

            return SingleChildScrollView(
              padding: EdgeInsets.all(sw * .05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //-------------------------------------------------
                  // DAILY ROUTINE
                  //-------------------------------------------------
                  _sectionTitle("Daily Routine", sw),

                  _textField(wakeupController, "Wake Up Time"),
                  _textField(officeController, "Office Time"),
                  _textField(breakController, "Break Time"),
                  _textField(workoutTimeController, "Workout Time"),
                  _textField(exerciseController, "Exercise Duration"),
                  _textField(sleepController, "Sleep Hours"),
                  _textField(waterController, "Water Intake"),

                  SizedBox(height: sh * .03),

                  //-------------------------------------------------
                  // DIET
                  //-------------------------------------------------
                  _sectionTitle("Diet Preference", sw),

                  const Text(
                    "Dietary Preferences",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  _chipSection(
                    options: dietOptions,
                    selectedList: selectedDiet,
                  ),

                  const SizedBox(height: 20),

                  _textField(allergiesController, "Allergies"),

                  _textField(mealsController, "Meals Per Day"),

                  _textField(budgetController, "Budget"),

                  _textField(commentsController, "Comments"),

                  SizedBox(height: sh * .03),

                  //-------------------------------------------------
                  // WORKOUT
                  //-------------------------------------------------
                  _sectionTitle("Workout Preference", sw),

                  _dropdown(
                    "Workout Preference",
                    workoutPrefer,
                    workoutPreferenceOptions,
                    (value) {
                      setState(() {
                        workoutPrefer = value!;
                      });
                    },
                  ),

                  _dropdown(
                    "Workout Place",
                    workoutPlace,
                    workoutPlaceOptions,
                    (value) {
                      setState(() {
                        workoutPlace = value!;
                      });
                    },
                  ),

                  _dropdown(
                    "Equipment Preference",
                    equipmentPrefer,
                    equipmentOptions,
                    (value) {
                      setState(() {
                        equipmentPrefer = value!;
                      });
                    },
                  ),

                  _dropdown("Workout Split", split, splitOptions, (value) {
                    setState(() {
                      split = value!;
                    });
                  }),

                  _dropdown("Fitness Level", fitnessLevel, fitnessOptions, (
                    value,
                  ) {
                    setState(() {
                      fitnessLevel = value!;
                    });
                  }),

                  SizedBox(height: sh * .03),

                  //-------------------------------------------------
                  // SKIN CARE
                  //-------------------------------------------------
                  _sectionTitle("Skin Care", sw),

                  _dropdown("Skin Tone", skinTone, skinToneOptions, (value) {
                    setState(() {
                      skinTone = value!;
                    });
                  }),

                  const Text(
                    "Skin Concerns",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  _chipSection(
                    options: skinConcernOptions,
                    selectedList: selectedSkinConcerns,
                  ),

                  SizedBox(height: sh * .03),

                  //-------------------------------------------------
                  // HAIR CARE
                  //-------------------------------------------------
                  _sectionTitle("Hair Care", sw),

                  _dropdown("Hair Type", hairType, hairTypeOptions, (value) {
                    setState(() {
                      hairType = value!;
                    });
                  }),

                  _dropdown("Scalp Type", scalpType, scalpOptions, (value) {
                    setState(() {
                      scalpType = value!;
                    });
                  }),

                  const Text(
                    "Hair Concerns",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  _chipSection(
                    options: hairConcernOptions,
                    selectedList: selectedHairConcerns,
                  ),

                  SizedBox(height: sh * .05),

                  //-------------------------------------------------
                  // UPDATE BUTTON
                  //-------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : updatePlan,
                      child: isSaving
                          ? const CircularProgressIndicator()
                          : const Text("Update Plan"),
                    ),
                  ),

                  SizedBox(height: sh * .03),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> updatePlan() async {
    if (profile == null) return;

    setState(() {
      isSaving = true;
    });

    try {
      final updatedProfile = UserProfileModel(
        //========================================================
        // BASIC DETAILS
        //========================================================
        uid: profile!.uid,
        fullName: profile!.fullName,
        age: profile!.age,
        gender: profile!.gender,
        height: profile!.height,
        weight: profile!.weight,
        phone: profile!.phone,

        //========================================================
        // GOAL DETAILS
        //========================================================
        goal: profile!.goal,
        targetWeight: profile!.targetWeight,
        durationMonths: profile!.durationMonths,

        muscleGainTarget: profile!.muscleGainTarget,
        strengthGoal: profile!.strengthGoal,
        primaryLift: profile!.primaryLift,
        repRange: profile!.repRange,

        enduranceGoal: profile!.enduranceGoal,
        cardioPreference: profile!.cardioPreference,

        fitnessGoals: profile!.fitnessGoals,

        workoutPlace: workoutPlace,

        sportName: profile!.sportName,

        performanceGoals: profile!.performanceGoals,

        competitionLevel: profile!.competitionLevel,

        workoutDays: profile!.workoutDays,

        //========================================================
        // ACTIVITY
        //========================================================
        activityLevel: profile!.activityLevel,

        //========================================================
        // DIET
        //========================================================
        dietaryPreferences: selectedDiet,
        allergies: allergiesController.text.trim(),
        comments: commentsController.text.trim(),
        mealsPerDay: mealsController.text.trim(),

        //========================================================
        // DAILY ROUTINE
        //========================================================
        sleepHours: sleepController.text.trim(),
        waterIntake: waterController.text.trim(),

        job: profile!.job,

        workoutTime: workoutTimeController.text.trim(),

        officeTime: officeController.text.trim(),

        breakTime: breakController.text.trim(),

        exercise: exerciseController.text.trim(),

        wakeUp: wakeupController.text.trim(),

        budget: budgetController.text.trim(),

        //========================================================
        // WORKOUT
        //========================================================
        workoutPrefer: workoutPrefer,
        equipmentPrefer: equipmentPrefer,
        split: split,

        //========================================================
        // SKIN
        //========================================================
        skinTone: skinTone,
        skinConcerns: selectedSkinConcerns,

        //========================================================
        // HAIR
        //========================================================
        hairType: hairType,
        hairConcerns: selectedHairConcerns,
        scalpType: scalpType,

        //========================================================
        // BODY
        //========================================================
        bodyType: profile!.bodyType,
        bodyGoal: profile!.bodyGoal,
        fitnessLevel: fitnessLevel,
      );

      await SupabaseService().updateUserProfile(updatedProfile);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Plan updated successfully."),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update plan.\n$e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        isSaving = false;
      });
    }
  }
}
