import 'package:fitnova/settings/editprofile.dart';
import 'package:fitnova/settings/mygoals.dart';
import 'package:fitnova/settings/myplan.dart';
// import 'package:dietplan/services/ai_service.dart';
import 'package:fitnova/login.dart';
import 'package:flutter/material.dart';
import 'package:fitnova/models/user_profile_model.dart';
import 'package:fitnova/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool generatingPlan = false;

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Settungs'), centerTitle: true),
      backgroundColor: Colors.grey.shade100,

      body: LayoutBuilder(
        builder: (context, constraints) {
          final sw = constraints.maxWidth;
          final sh = constraints.maxHeight;

          return FutureBuilder<UserProfileModel?>(
            future: SupabaseService().getUserProfile(user.id),

            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData) {
                return const Center(child: Text("Profile not found"));
              }

              final profile = snapshot.data!;

              // Avatar radius + name + email + spacing all derived from sw/sh
              final double avatarRadius = sw * 0.1;
              final double headerHeight =
                  sh *
                      0.05 // top padding
                      +
                  avatarRadius *
                      2 // avatar diameter
                      +
                  sh *
                      0.015 // gap after avatar
                      +
                  sw *
                      0.06 *
                      1.3 // name line height (~fontSize * 1.3)
                      +
                  sh *
                      0.008 // gap after name
                      +
                  sw *
                      0.038 *
                      1.3 // email line height
                      +
                  sh * 0.03; // bottom padding

              return SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: headerHeight,

                      decoration: BoxDecoration(
                        color: const Color(0xFF3A6F4B),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(sw * 0.06),
                          bottomRight: Radius.circular(sw * 0.06),
                        ),
                      ),

                      child: Padding(
                        padding: EdgeInsets.only(
                          top: sh * 0.05,
                          bottom: sh * 0.03,
                        ),

                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: avatarRadius,
                              backgroundColor: Colors.white,

                              child: Icon(
                                Icons.person,
                                size: avatarRadius,
                                color: const Color(0xFF3A6F4B),
                              ),
                            ),

                            SizedBox(height: sh * 0.015),

                            Text(
                              profile.fullName,
                              style: TextStyle(
                                fontSize: sw * 0.055,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            SizedBox(height: sh * 0.008),

                            Text(
                              user.email ?? '',
                              style: TextStyle(
                                fontSize: sw * 0.035,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: sh * 0.02),

                    Expanded(
                      child: ListView(
                        children: [
                          SettingsProfile(
                            icon: Icons.person_outline,
                            title: "Edit Profile",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfileScreen(),
                                ),
                              );
                            },
                          ),

                          SettingsProfile(
                            icon: Icons.flag_outlined,
                            title: "My Goals",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyGoalsScreen(),
                                ),
                              );
                            },
                          ),

                          SettingsProfile(
                            icon: Icons.restaurant_menu_outlined,
                            title: "My Plan",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MyPlanScreen(),
                                ),
                              );
                            },
                          ),

                          SettingsProfile(
                            icon: Icons.auto_awesome,
                            title: generatingPlan
                                ? "Generating Plan..."
                                : "Generate New Plan",

                            onTap: generatingPlan
                                ? null
                                : () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Generate New Plan",
                                          ),

                                          content: const Text(
                                            "This will replace your current meal plan. Continue?",
                                          ),

                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context, false);
                                              },
                                              child: const Text("Cancel"),
                                            ),

                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                              },
                                              child: const Text("Generate"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirm != true) return;

                                    try {
                                      setState(() {
                                        generatingPlan = true;
                                      });

                                      await SupabaseService()
                                          .generateAndSavePlans(user.id);

                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              "New meal and workout plan generated successfully",
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(content: Text(e.toString())),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          generatingPlan = false;
                                        });
                                      }
                                    }
                                  },
                          ),

                          SettingsProfile(
                            icon: Icons.logout,
                            title: "Logout",
                            onTap: () async {
                              await Supabase.instance.client.auth.signOut();

                              if (context.mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SettingsProfile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  const SettingsProfile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final sw = constraints.maxWidth;
        // final sh = constraints.maxHeight;

        return InkWell(
          onTap: onTap,

          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: sw * 0.05,
              vertical: sw * 0.045,
            ),

            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),

            child: Row(
              children: [
                Icon(icon, size: sw * 0.06, color: Colors.black87),

                SizedBox(width: sw * 0.04),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: sw * 0.042,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Icon(Icons.chevron_right, color: Colors.grey, size: sw * 0.055),
              ],
            ),
          ),
        );
      },
    );
  }
}
