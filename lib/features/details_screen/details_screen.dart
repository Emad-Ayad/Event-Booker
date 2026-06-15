import 'package:event_hub/features/details_screen/views/CircleIconButton.dart';
import 'package:event_hub/features/details_screen/views/InfoItem.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/HomeRemoteDataSource.dart';
import '../../data/model/EventModel.dart';
import '../../data/repo/HomeRepo.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event; // basic data from the list

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late final HomeRepo repo;
  EventModel? fullEvent;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    repo = HomeRepo(HomeRemoteDataSource());
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final data = await repo.getEventById(widget.event.id);
      setState(() {
        fullEvent = data;
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        fullEvent = widget.event;
        isLoading = false;
      });
    }
  }

  EventModel get event => fullEvent ?? widget.event;

  String _formatDateLong(String? date, String? time) {
    if (date == null) return 'Date TBA';
    try {
      final parts = date.split('-');
      const months = [
        '', 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December',
      ];
      const days = ['', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final dt = DateTime.parse(date);
      final month = months[int.parse(parts[1])];
      final day = int.parse(parts[2]);
      final weekday = days[dt.weekday];
      final timePart = time != null
          ? ', ${time.substring(0, 5)}'
          : '';
      return '$day $month, ${parts[0]}';
    } catch (_) {
      return date;
    }
  }

  String _formatTime(String? time) {
    if (time == null) return 'Time TBA';
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final suffix = hour >= 12 ? 'PM' : 'AM';
      final h = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$h:$minute $suffix';
    } catch (_) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Column(
              children: [
                // Cover image
                SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: event.imageUrl.isNotEmpty
                      ? Image.network(
                    event.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF5669FF),
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.white, size: 48),
                    ),
                  )
                      : Container(color: const Color(0xFF5669FF)),
                ),

                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 70, 24, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          event.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            color: Color(0xFF120D26),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Date
                        InfoItem(
                          icon: Icons.calendar_month,
                          title: _formatDateLong(
                              event.localDate, event.localTime),
                          subtitle: _formatTime(event.localTime),
                        ),
                        const SizedBox(height: 16),

                        // Venue
                        InfoItem(
                          icon: Icons.location_on,
                          title: event.venueName ?? 'Venue TBA',
                          subtitle: event.cityName ?? '',
                        ),
                        const SizedBox(height: 16),

                        // Category row
                        if (event.segmentName != null) ...[
                          InfoItem(
                            icon: Icons.category,
                            title: event.segmentName!,
                            subtitle: 'Category',
                          ),
                          const SizedBox(height: 28),
                        ],

                        // About
                        const Text(
                          'About Event',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF120D26),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          event.info ??
                              event.pleaseNote ??
                              'No description available for this event.',
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.7,
                            color: Color(0xFF747688),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back button overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleIconButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Navigator.pop(context),
                ),
                CircleIconButton(
                  icon: Icons.bookmark_border,
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Attendees card
          Positioned(
            top: 225,
            left: 24,
            right: 24,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.people, color: Color(0xFF5669FF), size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'Going',
                    style: TextStyle(
                      color: Color(0xFF5669FF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5669FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Invite',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Buy ticket button
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: SizedBox(
              height: 58,
              child: ElevatedButton(
                onPressed:(){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5669FF),
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'GET TICKETS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}