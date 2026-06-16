import 'package:event_hub/features/home_screen/views/CategoryChip.dart';
import 'package:event_hub/features/home_screen/views/EventCard.dart';
import 'package:event_hub/features/home_screen/views/InviteButton.dart';
import 'package:event_hub/features/home_screen/views/NavItem.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/HomeRemoteDataSource.dart';
import '../../data/model/CategoryModel.dart';
import '../../data/model/EventModel.dart';
import '../../data/repo/HomeRepo.dart';
import '../../utill/my_text_field.dart';
import '../services/navigation/AppRoutes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeRepo repo;

  List<CategoryModel> categories = [];
  List<EventModel> upcomingEvents = [];
  List<EventModel> nearbyEvents = [];

  bool isLoading = true;
  bool isFilterLoading = false;
  String? errorMessage;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    repo = HomeRepo(HomeRemoteDataSource());
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    try {
      final data = await repo.getHomeData();
      setState(() {
        categories = data.categories;
        upcomingEvents = data.upcomingEvents;
        nearbyEvents = data.nearbyEvents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> onCategoryTapped(String title) async {
    final newSelection = selectedCategory == title ? null : title;

    setState(() {
      selectedCategory = newSelection;
      isFilterLoading = true;
    });

    try {
      if (newSelection == null) {
        final upcoming = await repo.getUpcomingEvents();
        final nearby = await repo.getNearbyEvents();
        setState(() {
          upcomingEvents = upcoming;
          nearbyEvents = nearby;
        });
      } else {
        final filtered = await repo.getEventsByCategory(newSelection);
        setState(() {
          upcomingEvents = filtered;
          nearbyEvents = filtered;
        });
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      setState(() => isFilterLoading = false);
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              errorMessage!,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(Icons.menu, color: Colors.white, size: 28),
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
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.18),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.tune, color: Colors.white70, size: 20),
                                        SizedBox(width: 6),
                                        Text(
                                          'Filters',
                                          style: TextStyle(color: Colors.white),
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
                          itemCount: categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return CategoryChip(
                              title: category.title,
                              color: category.color,
                              icon: category.icon,
                              isSelected: selectedCategory == category.title,
                              onTap: () => onCategoryTapped(category.title),
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

                      if (isFilterLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                        SizedBox(
                          height: 280,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: upcomingEvents.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              return EventCard(event: upcomingEvents[index]);
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
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

                      if (isFilterLoading)
                        const Center(child: CircularProgressIndicator())
                      else
                      SizedBox(
                        height: 280,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: nearbyEvents.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            return EventCard(event: nearbyEvents[index]);
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
                        child: const Icon(Icons.add, color: Colors.white, size: 30),
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
