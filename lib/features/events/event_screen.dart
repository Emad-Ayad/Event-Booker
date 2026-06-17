import 'package:event_hub/features/search/views/SearchCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/EventModel.dart';
import '../services/navigation/AppRoutes.dart';
import 'cubit/event_cubit.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

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
      body: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          if (state is EventsInitial || state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EventsError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(state.message, textAlign: TextAlign.center),
              ),
            );
          }

          if (state is! EventsLoaded) {
            return const SizedBox.shrink();
          }

          if (state.events.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: ListView.separated(
              itemCount: state.events.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final event = state.events[index];
                return SearchCard(
                  imageUrl: event.imageUrl,
                  date: formatDate(event.localDate, event.localTime),
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
        },
      ),
    );
  }

  String formatDate(String? date, String? time) {
    if (date == null) return '';
    try {
      final parts = date.split('-');
      final months = [
        '', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL',
        'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
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
