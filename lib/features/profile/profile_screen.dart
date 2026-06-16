import 'package:event_hub/features/profile/views/ProfileStat.dart';
import 'package:event_hub/features/search/views/SearchCard.dart';
import 'package:flutter/material.dart';

import '../../data/local/AppDatabase.dart';
import '../../data/local/SessionManager.dart';
import '../../data/local/auth_local_data_source.dart';
import '../../data/model/UserModel.dart';
import '../home_screen/views/EventCard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? currentUser;
  bool isLoading = true;
  String? errorMessage;

  final List<Map<String, String>> events = [
    {
      'image': 'assets/images/event1.png',
      'date': '1ST MAY- SAT -2:00 PM',
      'title': 'A virtual evening of smooth jazz',
    },
    {
      'image': 'assets/images/event2.png',
      'date': '1ST MAY- SAT -2:00 PM',
      'title': 'Jo malone london’s mother’s day',
    },
    {
      'image': 'assets/images/event1.png',
      'date': '1ST MAY- SAT -2:00 PM',
      'title': 'A virtual evening of smooth jazz',
    },
    {
      'image': 'assets/images/event2.png',
      'date': '1ST MAY- SAT -2:00 PM',
      'title': 'Jo malone london’s mother’s day',
    },
    {
      'image': 'assets/images/event1.png',
      'date': '1ST MAY- SAT -2:00 PM',
      'title': 'Women\'s leadership conference',
    },
    {
      'image': 'assets/images/event2.png',
      'date': '1ST MAY- SAT -2:00 PM',
      'title': 'International kids safe parents night out',
    },
    {
      'image': 'assets/images/event1.png',
      'date': '1ST MAY- SAT -2:00 PM',
      'title': 'International gala music festival',
    },
  ];

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    try {
      final email = await SessionManager.getLoggedInUserEmail();

      if (email == null) {
        setState(() {
          errorMessage = 'No logged in user found';
          isLoading = false;
        });
        return;
      }

      final db = await AppDatabase.instance.database;
      final authLocal = AuthLocalDataSource(db);
      final user = await authLocal.getUserByEmail(email);

      setState(() {
        currentUser = user;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF8F8FB),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F8FB),
        body: Center(
          child: Text(errorMessage!, style: const TextStyle(fontSize: 16)),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8FB),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF120D26),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert,
                        color: Color(0xFF120D26),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                const CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/images/person2.png'),
                ),
                const SizedBox(height: 18),

                Text(
                  currentUser?.fullName ?? 'Unknown User',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF120D26),
                  ),
                ),
                const SizedBox(height: 18),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileStat(number: '350', label: 'Following'),
                    SizedBox(width: 28),
                    SizedBox(
                      height: 38,
                      child: VerticalDivider(
                        color: Color(0xFFE4E4EE),
                        thickness: 1,
                      ),
                    ),
                    SizedBox(width: 28),
                    ProfileStat(number: '346', label: 'Followers'),
                  ],
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 52,
                      width: 150,
                      decoration: BoxDecoration(
                        color:  Colors.red,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 52,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF5669FF)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.edit, color: Color(0xFF5669FF), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Color(0xFF5669FF),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                const TabBar(
                  indicatorColor: Color(0xFF5669FF),
                  indicatorWeight: 3,
                  labelColor: Color(0xFF5669FF),
                  unselectedLabelColor: Color(0xFF747688),
                  labelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(text: 'ABOUT'),
                    Tab(text: 'EVENT'),
                    Tab(text: 'REVIEWS'),
                  ],
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: TabBarView(
                    children: [
                      const Center(
                        child: Text(
                          'About Content',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      ListView.separated(
                        itemCount: events.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final event = events[index];
                          return SearchCard(
                            imageUrl: event['image']!,
                            date: event['date']!,
                            title: event['title']!,
                          );
                        },
                      ),
                      const Center(
                        child: Text(
                          'Reviews Content',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
