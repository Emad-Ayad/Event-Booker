import 'package:event_hub/features/home_screen/views/CategoryChip.dart';
import 'package:event_hub/features/home_screen/views/EventCard.dart';
import 'package:event_hub/features/home_screen/views/InviteButton.dart';
import 'package:event_hub/features/home_screen/views/NavItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utill/my_text_field.dart';
import '../services/navigation/AppRoutes.dart';
import 'cubit/home_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8F8FB),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is HomeError) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F8FB),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  state.message,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final loadedState = state as HomeLoaded;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F8FB),
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color(0xFF5669FF),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(36),
                              bottomRight: Radius.circular(36),
                            ),
                          ),
                          child: SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                      Column(
                                        children: const [
                                          SizedBox(height: 12),
                                          Text(
                                            'Current Location',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'New York, USA',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.18),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.notifications_none,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: MyTextField(),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        height: 48,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.18),
                                          borderRadius:
                                          BorderRadius.circular(14),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.tune,
                                              color: Colors.white70,
                                              size: 20,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              'Filters',
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 4,
                          right: 4,
                          bottom: -15,
                          child: SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: loadedState.categories.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final category = loadedState.categories[index];
                                return CategoryChip(
                                  title: category.title,
                                  color: category.color,
                                  icon: category.icon,
                                  isSelected:
                                  loadedState.selectedCategory ==
                                      category.title,
                                  onTap: () {
                                    context
                                        .read<HomeCubit>()
                                        .onCategoryTapped(category.title);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          sectionHeader('Upcoming Events'),
                          const SizedBox(height: 16),
                          if (loadedState.isFilterLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            SizedBox(
                              height: 280,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: loadedState.upcomingEvents.length,
                                separatorBuilder: (_, __) =>
                                const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  return EventCard(
                                    event: loadedState.upcomingEvents[index],
                                  );
                                },
                              ),
                            ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 18, left: 18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF95F3F3),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 8,
                                  bottom: -40,
                                  child: Image.asset(
                                    'assets/images/gift_box.png',
                                    width: 350,
                                    height: 180,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Invite your friends',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF120D26),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Get \$20 for ticket',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFF747688),
                                            ),
                                          ),
                                          SizedBox(height: 14),
                                          InviteButton(),
                                          SizedBox(height: 14),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          sectionHeader('Nearby You'),
                          const SizedBox(height: 16),
                          if (loadedState.isFilterLoading)
                            const Center(child: CircularProgressIndicator())
                          else
                            SizedBox(
                              height: 280,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: loadedState.nearbyEvents.length,
                                separatorBuilder: (_, __) =>
                                const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  return EventCard(
                                    event: loadedState.nearbyEvents[index],
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: 72,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NavItem(
                              icon: Icons.explore,
                              label: 'Explore',
                              isSelected: true,
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.home);
                              },
                            ),
                            NavItem(
                              icon: Icons.calendar_month,
                              label: 'Events',
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.events);
                              },
                            ),
                            const SizedBox(width: 44),
                            NavItem(
                              icon: Icons.search,
                              label: 'Search',
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.search);
                              },
                            ),
                            NavItem(
                              icon: Icons.person,
                              label: 'Profile',
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.profile);
                              },
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -18,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: Color(0xFF5669FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget sectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF120D26),
          ),
        ),
        const Spacer(),
        const Text(
          'See All',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF747688),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: Color(0xFF747688),
        ),
      ],
    );
  }
}