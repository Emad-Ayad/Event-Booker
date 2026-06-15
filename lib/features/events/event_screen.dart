import 'package:event_hub/features/search/views/SearchCard.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

import '../../data/datasource/HomeRemoteDataSource.dart';
import '../../data/model/EventModel.dart';
import '../../data/repo/HomeRepo.dart';
import '../services/navigation/AppRoutes.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late final HomeRepo repo;
  List<EventModel> events = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    repo = HomeRepo(HomeRemoteDataSource());
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      final result = await repo.getAllEvents();
      setState(() {
        events = result;
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8FB),
        elevation: 0,
        surfaceTintColor: const Color(0xFFF8F8FB),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF120D26)),
        ),
        title: const Text(
          'Events',
          style: TextStyle(
            color: Color(0xFF120D26),
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Color(0xFF120D26)),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: Color(0xFF120D26)),
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }
    if (events.isEmpty) {
      return const Center(child: Text('No events found.'));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: ListView.separated(
        itemCount: events.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final event = events[index];
          return SearchCard(
            imageUrl: event.imageUrl,
            date: _formatDate(event.localDate, event.localTime),
            title: event.name,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.eventDetails,
              arguments: event,
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String? date, String? time) {
    if (date == null) return '';
    try {
      final parts = date.split('-');
      final months = [
        '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
        'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
      ];
      final day = int.parse(parts[2]);
      final month = months[int.parse(parts[1])];
      final timePart = time != null ? ' · ${time.substring(0, 5)}' : '';
      return '$day $month$timePart';
    } catch (_) {
      return date;
    }
  }
}