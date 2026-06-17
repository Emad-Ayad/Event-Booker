import 'package:event_hub/features/profile/views/ProfileStat.dart';
import 'package:event_hub/features/search/views/SearchCard.dart';
import 'package:event_hub/features/services/navigation/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/EventModel.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String buildDateText(EventModel event) {
    final date = (event.localDate == null || event.localDate!.isEmpty)
        ? 'Date TBA'
        : event.localDate!;
    final time = (event.localTime == null || event.localTime!.isEmpty)
        ? ''
        : ' - ${event.localTime}';
    return '$date$time';
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      context.read<ProfileCubit>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.signIn,
                (route) => false,
          );
        }
      },
      builder: (context, state) {
        if (state is ProfileInitial || state is ProfileLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8F8FB),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F8FB),
            body: Center(
              child: Text(
                state.message,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }

        if (state is! ProfileLoaded) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8F8FB),
            body: SizedBox.shrink(),
          );
        }

        final profileState = state;

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
                      profileState.currentUser.fullName,
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
                        GestureDetector(
                          onTap:  () {
                            showLogoutDialog(context);
                          },
                          child: Container(
                            height: 52,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              border: Border.all(color: Colors.red),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.exit_to_app,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text('Logout',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 52,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFF5669FF),
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit,
                                color: Color(0xFF5669FF),
                                size: 20,
                              ),
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
                          profileState.savedEvents.isEmpty
                              ? const Center(
                            child: Text(
                              'No saved events yet',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                              : ListView.separated(
                            itemCount: profileState.savedEvents.length,
                            separatorBuilder: (_, __) =>
                            const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              final event =
                              profileState.savedEvents[index];
                              return SearchCard(
                                imageUrl: event.imageUrl,
                                date: buildDateText(event),
                                title: event.name,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.eventDetails,
                                  arguments: event,
                                ),
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
      },
    );
  }
}