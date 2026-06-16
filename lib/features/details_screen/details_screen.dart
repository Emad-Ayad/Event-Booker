import 'package:event_hub/features/details_screen/views/CircleIconButton.dart';
import 'package:event_hub/features/details_screen/views/InfoItem.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/HomeRemoteDataSource.dart';
import '../../data/local/AppDatabase.dart';
import '../../data/local/SavedEventsLocalDataSource.dart';
import '../../data/local/SessionManager.dart';
import '../../data/model/EventModel.dart';
import '../../data/repo/HomeRepo.dart';


class EventDetailsScreen extends StatefulWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late final HomeRepo repo;
  EventModel? fullEvent;
  bool isLoading = true;
  bool isSaved = false;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    repo = HomeRepo(HomeRemoteDataSource());
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    userEmail = await SessionManager.getLoggedInUserEmail();
    await _loadDetails();
    await _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    if (userEmail == null) return;

    final db = await AppDatabase.instance.database;
    final savedDataSource = SavedEventsLocalDataSource(db);
    final saved = await savedDataSource.isEventSaved(
      userEmail: userEmail!,
      eventId: widget.event.id,
    );

    if (!mounted) return;
    setState(() {
      isSaved = saved;
    });
  }

  Future<void> _toggleSaveEvent() async {
    try {
      if (userEmail == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No logged in user found')),
        );
        return;
      }

      final db = await AppDatabase.instance.database;
      final savedDataSource = SavedEventsLocalDataSource(db);

      if (isSaved) {
        await savedDataSource.removeEvent(
          userEmail: userEmail!,
          eventId: event.id,
        );

        if (!mounted) return;
        setState(() => isSaved = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from saved events')),
        );
      } else {
        await savedDataSource.saveEvent(
          userEmail: userEmail!,
          event: event,
        );

        if (!mounted) return;
        setState(() => isSaved = true);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved to your events')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _loadDetails() async {
    try {
      final data = await repo.getEventById(widget.event.id);
      if (!mounted) return;
      setState(() {
        fullEvent = data;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
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
        '',
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ];
      final month = months[int.parse(parts[1])];
      final day = int.parse(parts[2]);
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
                SizedBox(
                  height: 260,
                  width: double.infinity,
                  child: event.imageUrl.isNotEmpty
                      ? Image.network(
                    event.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF5669FF),
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                        size: 48,
                      ),
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
                        InfoItem(
                          icon: Icons.calendar_month,
                          title: _formatDateLong(
                            event.localDate,
                            event.localTime,
                          ),
                          subtitle: _formatTime(event.localTime),
                        ),
                        const SizedBox(height: 16),
                        InfoItem(
                          icon: Icons.location_on,
                          title: event.venueName ?? 'Venue TBA',
                          subtitle: event.cityName ?? '',
                        ),
                        const SizedBox(height: 16),
                        if (event.segmentName != null) ...[
                          InfoItem(
                            icon: Icons.category,
                            title: event.segmentName!,
                            subtitle: 'Category',
                          ),
                          const SizedBox(height: 28),
                        ],
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
                  icon: isSaved ? Icons.bookmark : Icons.bookmark_border,
                  iconColor: isSaved ? const Color(0xFF5669FF) : Colors.white,
                  onTap: _toggleSaveEvent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}