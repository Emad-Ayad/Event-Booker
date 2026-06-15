import 'package:event_hub/features/search/views/SearchCard.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8FB),
        elevation: 0,
        surfaceTintColor: const Color(0xFFF8F8FB),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF120D26),
          ),
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
            icon: const Icon(
              Icons.search,
              color: Color(0xFF120D26),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Color(0xFF120D26),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: ListView.separated(
          itemCount: events.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final event = events[index];
            return SearchCard(
              image: event['image']!,
              date: event['date']!,
              title: event['title']!,
            );
          },
        ),
      ),
    );
  }
}
