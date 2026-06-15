import 'package:event_hub/features/search/views/SearchCard.dart';
import 'package:event_hub/utill/my_text_field.dart';
import 'package:flutter/material.dart';


class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF120D26),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7381F5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: MyTextField()
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8796FF),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.tune, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Filters',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              Expanded(
                child: ListView.separated(
                  itemCount: events.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
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
            ],
          ),
        ),
      ),
    );
  }
}
