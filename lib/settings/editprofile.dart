import 'package:fitnova/models/user_profile_model.dart';
import 'package:fitnova/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final phoneController = TextEditingController();
  String gender = "Male";
  String skinTone = "";
  String hairType = "";
  String scalpType = "";
  bool isLoading = true;
  bool isSaving = false;
  UserProfileModel? profile;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;
    final data = await SupabaseService().getUserProfile(user.id);

    if (data != null) {
      profile = data;
      fullNameController.text = data.fullName;
      ageController.text = data.age.toString();
      heightController.text = data.height.toString();
      weightController.text = data.weight.toString();
      phoneController.text = data.phone.toString();
      gender = data.gender;
      skinTone = data.skinTone;
      hairType = data.hairType;
      scalpType = data.scalpType;
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    final updatedProfile = UserProfileModel(
      uid: profile!.uid,
      fullName: fullNameController.text.trim(),
      age: int.parse(ageController.text.trim()),
      gender: gender,
      height: double.parse(heightController.text.trim()),
      weight: double.parse(weightController.text.trim()),
      phone: int.parse(phoneController.text.trim()),
      goal: profile!.goal,
      targetWeight: profile!.targetWeight,
      durationMonths: profile!.durationMonths,
      muscleGainTarget: profile!.muscleGainTarget,
      sportName: profile!.sportName,
      strengthGoal: profile!.strengthGoal,
      primaryLift: profile!.primaryLift,
      repRange: profile!.repRange,
      enduranceGoal: profile!.enduranceGoal,
      cardioPreference: profile!.cardioPreference,
      fitnessGoals: profile!.fitnessGoals,
      workoutPlace: profile!.workoutPlace,
      performanceGoals: profile!.performanceGoals,
      competitionLevel: profile!.competitionLevel,
      workoutDays: profile!.workoutDays,
      activityLevel: profile!.activityLevel,
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
      skinTone: skinTone,
      skinConcerns: profile!.skinConcerns,
      hairType: hairType,
      hairConcerns: profile!.hairConcerns,
      scalpType: scalpType,
      bodyType: profile!.bodyType,
      bodyGoal: profile!.bodyGoal,
      fitnessLevel: profile!.fitnessLevel,
    );

    await SupabaseService().updateUserProfile(updatedProfile);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully")),
      );

      Navigator.pop(context);
    }

    setState(() {
      isSaving = false;
    });
  }

  @override
  void dispose() {
    fullNameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile"), centerTitle: true),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final sw = constraints.maxWidth;
            final sh = constraints.maxHeight;

            return SingleChildScrollView(
              padding: EdgeInsets.all(sw * 0.05),

              child: Form(
                key: _formKey,

                child: Column(
                  children: [
                    CircleAvatar(
                      radius: sw * 0.12,

                      backgroundColor: const Color(0xFF3A6F4B),

                      child: Icon(
                        Icons.person,
                        size: sw * 0.12,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: sh * 0.03),

                    TextFormField(
                      controller: fullNameController,

                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter name";
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: sh * 0.02),

                    TextFormField(
                      controller: ageController,

                      keyboardType: TextInputType.number,

                      decoration: const InputDecoration(
                        labelText: "Age",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: sh * 0.02),

                    DropdownButtonFormField(
                      value: gender,

                      decoration: const InputDecoration(
                        labelText: "Gender",
                        border: OutlineInputBorder(),
                      ),

                      items: const [
                        DropdownMenuItem(value: "Male", child: Text("Male")),

                        DropdownMenuItem(
                          value: "Female",
                          child: Text("Female"),
                        ),
                      ],

                      onChanged: (value) {
                        setState(() {
                          gender = value!;
                        });
                      },
                    ),

                    SizedBox(height: sh * 0.02),

                    TextFormField(
                      controller: heightController,

                      keyboardType: TextInputType.number,

                      decoration: const InputDecoration(
                        labelText: "Height (cm)",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: sh * 0.02),

                    TextFormField(
                      controller: weightController,

                      keyboardType: TextInputType.number,

                      decoration: const InputDecoration(
                        labelText: "Weight (kg)",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: sh * 0.02),

                    DropdownButtonFormField<String>(
                      value: skinTone.isEmpty ? null : skinTone,
                      decoration: const InputDecoration(
                        labelText: "Skin Tone",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: "Fair", child: Text("Fair")),
                        DropdownMenuItem(value: "Light", child: Text("Light")),
                        DropdownMenuItem(
                          value: "Wheatish",
                          child: Text("Wheatish"),
                        ),
                        DropdownMenuItem(value: "Brown", child: Text("Brown")),
                        DropdownMenuItem(value: "Dark", child: Text("Dark")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          skinTone = value!;
                        });
                      },
                    ),

                    SizedBox(height: sh * .02),

                    DropdownButtonFormField<String>(
                      value: hairType.isEmpty ? null : hairType,
                      decoration: const InputDecoration(
                        labelText: "Hair Type",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Straight",
                          child: Text("Straight"),
                        ),
                        DropdownMenuItem(value: "Wavy", child: Text("Wavy")),
                        DropdownMenuItem(value: "Curly", child: Text("Curly")),
                        DropdownMenuItem(value: "Coily", child: Text("Coily")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          hairType = value!;
                        });
                      },
                    ),

                    SizedBox(height: sh * .02),

                    DropdownButtonFormField<String>(
                      value: scalpType.isEmpty ? null : scalpType,
                      decoration: const InputDecoration(
                        labelText: "Scalp Type",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Normal",
                          child: Text("Normal"),
                        ),
                        DropdownMenuItem(value: "Dry", child: Text("Dry")),
                        DropdownMenuItem(value: "Oily", child: Text("Oily")),
                        DropdownMenuItem(
                          value: "Combination",
                          child: Text("Combination"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          scalpType = value!;
                        });
                      },
                    ),

                    SizedBox(height: sh * .02),

                    TextFormField(
                      controller: phoneController,

                      keyboardType: TextInputType.number,

                      decoration: const InputDecoration(
                        labelText: "Phone No.",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: sh * 0.04),

                    SizedBox(
                      width: double.infinity,

                      height: sh * 0.065,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3A6F4B),
                        ),

                        onPressed: isSaving ? null : updateProfile,

                        child: isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Update Profile",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
