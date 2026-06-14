import 'package:flutter/material.dart';

class EventsToggle extends StatefulWidget {
  const EventsToggle({super.key});

  @override
  State<EventsToggle> createState() => _EventsToggleState();
}

class _EventsToggleState extends State<EventsToggle> {
  bool isUpcomingSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isUpcomingSelected = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isUpcomingSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'UPCOMING',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isUpcomingSelected
                        ? Colors.blue
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => isUpcomingSelected = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isUpcomingSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'PAST EVENTS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: !isUpcomingSelected
                        ?  Colors.blue
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}