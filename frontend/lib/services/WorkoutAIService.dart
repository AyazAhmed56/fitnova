import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fitnova/models/user_profile_model.dart';
import 'package:http/http.dart' as http;

class WorkoutAIService {
  final String workoutApiKey = dotenv.get('GEMINI_API_KEY_WORKOUT');

  Future<Map<String, dynamic>> generateWorkoutPlan(
    UserProfileModel profile,
  ) async {
    final workoutPrompt =
        """
You are an experienced fitness coach, gym trainer, and workout specialist.
Create a highly practical personalized transformation workout plan.

USER DETAILS
Name: ${profile.fullName}
Age: ${profile.age}
Gender: ${profile.gender}
Height: ${profile.height} cm
Weight: ${profile.weight} kg
Goal: ${profile.goal}
Target Weight: ${profile.targetWeight}
Duration: ${profile.durationMonths} months
Muscle Gain Target:${profile.muscleGainTarget}
Strength Goal:${profile.strengthGoal}
Primary Lift:${profile.primaryLift}
Rep Range:${profile.repRange}
Endurance Goal:${profile.enduranceGoal}
Cardio Preference:${profile.cardioPreference}
Fitness Goals:${profile.fitnessGoals.join(", ")}
Workout Place:${profile.workoutPlace}
Sport Name:${profile.sportName}
Performance Goal:${profile.performanceGoals.join(", ")}
Competition Level:${profile.competitionLevel}
Workout Days:${profile.workoutDays}
Activity Level:${profile.activityLevel}
Comments:${profile.comments}
Sleep Hours:${profile.sleepHours}
Daily Water Intake:${profile.waterIntake}
Preferred Exercise:${profile.exercise}
Workout Location:${profile.workoutPrefer}
Wake Up Time:${profile.wakeUp}
Job:${profile.job}
Job Time:${profile.officeTime}
Break Time:${profile.breakTime}
Workout Time:${profile.workoutTime}
Equipment Preference:${profile.equipmentPrefer}
Workout Split Preference:${profile.split} use it if the user is intermediate or advanced fitness goal
================================================
FITNESS PROFILE
Body Type:${profile.bodyType}
Body Goal:${profile.bodyGoal}
Fitness Experience:${profile.fitnessLevel}
================================================
IMPORTANT RULES
# make the plan that a person uses for a month so that they can feel or see some changes so 
* I am going to ask you questions, Suggest Evidence based Method solutions as per that
1. Create ONLY a 7-day workout plan.
2. Generate workouts only on the user's selected workout days.
3. Automatically make remaining days Recovery or Rest Days.
4. Design the program according to:
   - Goal
   - Body Type
   - Body Goal
   - Fitness Experience
   - Activity Level
5. Respect the user's preferred workout location.
6. If Workout Location is Home:
   • Use only bodyweight or available equipment.
   • Never recommend unavailable gym machines.
7. If Workout Location is Gym:
   • Use appropriate gym equipment.
8. Respect the Equipment Preference.
9. Respect the Workout Split preference.
Ignore this field if the user is Beginner.
10. Include:
   • Warm-up
   • Main Workout
   • Cool-down
   • Stretching
11. Every exercise must contain:
   • Exercise Name
   • Muscle Group
   • Equipment
   • Sets
   • Reps OR Duration
   • Rest Time
   • Difficulty
   • Instructions
   • Precautions
12. Keep exercise names short.
13. Use realistic sets, reps and rest periods.
14. Avoid overtraining the same muscle group on consecutive workout days.
15. Include progressive overload suggestions where appropriate.
16. Adjust workout intensity according to Fitness Experience.
17. Never recommend unsafe exercises for beginners.
18. Generate only practical workouts.
19. Return ONLY valid JSON.
20. Use this, based on the goal types otherwise ignore it.
Muscle Gain Target for build muscle
Strength Goal, Primary Lift, Rep Range for strength and power
Endurance Goal, Cardio Preference for improve endurance
Fitness Goals, Workout Place for generl fitness
Sport Name, Performance Goal, Competition Level for Athletic Performance

21. For compound exercises include proper form instructions in 3-5 short steps.
22. Do not repeat the same workout on consecutive workout days unless necessary.
23. Only choose standard exercise names. Do not invent custom exercise names. Use internationally recognized exercise names so they can later be matched with an exercise database.
24. Keep the days fixed monday, tuesday, wednesday, thursday, friday, saturday, sunday. Don't give the days based on the current day

you MUST provide:
precautions:
- precautions list (Do's and Dont's)
instructions:
- step-by-step workout form process so that workout doen't go wrong
================================================

JSON FORMAT
{
  "note": "Generate a new workout plan after Week 1 for progression and variety.",
  "weeklySummary": {
    "goal": "",
    "fitnessLevel": "",
    "bodyType": "",
    "bodyGoal": "",
    "workoutDays": "",
    "restDays": "",
    "estimatedCaloriesBurnRange":"",
    "estimatedWorkoutDuration": "",
  },
  "days": {
    "Monday": {
      "dayName": "",
      "focus": "",
      "estimatedDuration": "",
      "difficulty": "",
      "warmUp": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "workout": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "exerciseType": "",
          "exerciseOrder": "",
          "isCompound": true,
          "muscleGroup": "",
          "secondaryMuscles": [],
          "equipmentRequired": "",
          "sets": "",
          "reps": "",
          "duration": "",
          "rest": "",
          "tempo": "",
          "difficulty": "",
          "instructions": [],
          "precautions": [],
          "commonMistakes": [],
          "substituteExercises": [],
          "tips": [],
        }
      ],
      "coolDown": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "stretching": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "dailyTips": [],
      "precautions": [],
      "motivation": "",
      "notes": "",
    },
    "Tuesday": {
      "dayName": "",
      "focus": "",
      "estimatedDuration": "",
      "difficulty": "",
      "warmUp": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "workout": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "exerciseType": "",
          "exerciseOrder": "",
          "isCompound": true,
          "muscleGroup": "",
          "secondaryMuscles": [],
          "equipmentRequired": "",
          "sets": "",
          "reps": "",
          "duration": "",
          "rest": "",
          "tempo": "",
          "difficulty": "",
          "instructions": [],
          "precautions": [],
          "commonMistakes": [],
          "substituteExercises": [],
          "tips": [],
        }
      ],
      "coolDown": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "stretching": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "dailyTips": [],
      "precautions": [],
      "motivation": "",
      "notes": "",
    },
    "Wednesday": {
      "dayName": "",
      "focus": "",
      "estimatedDuration": "",
      "difficulty": "",
      "warmUp": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "workout": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "exerciseType": "",
          "exerciseOrder": "",
          "isCompound": true,
          "muscleGroup": "",
          "secondaryMuscles": [],
          "equipmentRequired": "",
          "sets": "",
          "reps": "",
          "duration": "",
          "rest": "",
          "tempo": "",
          "difficulty": "",
          "instructions": [],
          "precautions": [],
          "commonMistakes": [],
          "substituteExercises": [],
          "tips": [],
        }
      ],
      "coolDown": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "stretching": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "dailyTips": [],
      "precautions": [],
      "motivation": "",
      "notes": "",
    },
    "Thursday": {
      "dayName": "",
      "focus": "",
      "estimatedDuration": "",
      "difficulty": "",
      "warmUp": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "workout": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "exerciseType": "",
          "exerciseOrder": "",
          "isCompound": true,
          "muscleGroup": "",
          "secondaryMuscles": [],
          "equipmentRequired": "",
          "sets": "",
          "reps": "",
          "duration": "",
          "rest": "",
          "tempo": "",
          "difficulty": "",
          "instructions": [],
          "precautions": [],
          "commonMistakes": [],
          "substituteExercises": [],
          "tips": [],
        }
      ],
      "coolDown": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "stretching": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "dailyTips": [],
      "precautions": [],
      "motivation": "",
      "notes": "",
    },
    "Friday": {
      "dayName": "",
      "focus": "",
      "estimatedDuration": "",
      "difficulty": "",
      "warmUp": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "workout": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "exerciseType": "",
          "exerciseOrder": "",
          "isCompound": true,
          "muscleGroup": "",
          "secondaryMuscles": [],
          "equipmentRequired": "",
          "sets": "",
          "reps": "",
          "duration": "",
          "rest": "",
          "tempo": "",
          "difficulty": "",
          "instructions": [],
          "precautions": [],
          "commonMistakes": [],
          "substituteExercises": [],
          "tips": [],
        }
      ],
      "coolDown": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "stretching": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "dailyTips": [],
      "precautions": [],
      "motivation": "",
      "notes": "",
    },
    "Saturday": {
      "dayName": "",
      "focus": "",
      "estimatedDuration": "",
      "difficulty": "",
      "warmUp": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "workout": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "exerciseType": "",
          "exerciseOrder": "",
          "isCompound": true,
          "muscleGroup": "",
          "secondaryMuscles": [],
          "equipmentRequired": "",
          "sets": "",
          "reps": "",
          "duration": "",
          "rest": "",
          "tempo": "",
          "difficulty": "",
          "instructions": [],
          "precautions": [],
          "commonMistakes": [],
          "substituteExercises": [],
          "tips": [],
        }
      ],
      "coolDown": [
        {
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "stretching": [
        {
          "bodyPart":"",
          "exerciseId": "",
          "exerciseName": "",
          "duration": "",
          "instructions": [],
        }
      ],
      "dailyTips": [],
      "precautions": [],
      "motivation": "",
      "notes": "",
    },
    "Sunday": {
      "restDay": true,
      "activity": "Complete Rest",
      "recoveryTips": [""],
      "stretching": [],
      "notes": "",
    }
  }
}
================================================
IMPORTANT:
Return ONLY valid JSON.
Do NOT write:
- Hello
- Greetings
- Explanations
- Notes outside JSON
- Markdown
- ```json
- ```
Your response must start with { and end with }
Output ONLY JSON.
""";

    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$workoutApiKey",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": workoutPrompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 503) {
      throw Exception(
        "Gemini servers are busy. Please try again in a few moments.",
      );
    }

    if (response.statusCode != 200) {
      throw Exception(
        "Gemini Error (${response.statusCode}) : ${response.body}",
      );
    }

    final data = jsonDecode(response.body);

    final text = data["candidates"][0]["content"]["parts"][0]["text"] ?? "";

    // print("========== GEMINI RESPONSE ==========");
    // print(text);
    // print("====================================");

    final cleaned = text.replaceAll("```json", "").replaceAll("```", "").trim();

    return jsonDecode(cleaned);
  }
}
