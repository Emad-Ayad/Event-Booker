import 'package:event_hub/features/details_screen/views/CircleIconButton.dart';
import 'package:event_hub/features/details_screen/views/InfoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/EventModel.dart';
import 'cubit/event_details_cubit.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailsScreen({super.key, required this.event});

  String formatDateLong(String? date) {
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

  String formatTime(String? time) {
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
    return BlocConsumer<EventDetailsCubit, EventDetailsState>(
      listener: (context, state) {
        if (state is EventDetailsActionSuccess) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is EventDetailsActionError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        EventModel currentEvent = event;
        bool isSaved = false;
        bool isLoading = true;
        bool isSaving = false;

        if (state is EventDetailsLoaded) {
          currentEvent = state.event;
          isSaved = state.isSaved;
          isLoading = false;
          isSaving = state.isSaving;
        } else if (state is EventDetailsActionSuccess) {
          currentEvent = state.event;
          isSaved = state.isSaved;
          isLoading = false;
        } else if (state is EventDetailsActionError) {
          currentEvent = state.event;
          isSaved = state.isSaved;
          isLoading = false;
        } else if (state is EventDetailsError) {
          currentEvent = state.event;
          isSaved = state.isSaved;
          isLoading = false;
        }

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
                      child: currentEvent.imageUrl.isNotEmpty
                          ? Image.network(
                              currentEvent.imageUrl,
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
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                70,
                                24,
                                110,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    currentEvent.name,
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
                                    title: formatDateLong(
                                      currentEvent.localDate,
                                    ),
                                    subtitle: formatTime(
                                      currentEvent.localTime,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  InfoItem(
                                    icon: Icons.location_on,
                                    title:
                                        currentEvent.venueName ?? 'Venue TBA',
                                    subtitle: currentEvent.cityName ?? '',
                                  ),
                                  const SizedBox(height: 16),
                                  if (currentEvent.segmentName != null) ...[
                                    InfoItem(
                                      icon: Icons.category,
                                      title: currentEvent.segmentName!,
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
                                    currentEvent.info ??
                                        currentEvent.pleaseNote ??
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
                      iconColor: isSaved
                          ? const Color(0xFF5669FF)
                          : Colors.white,
                      onTap: isSaving
                          ? () {}
                          : () {
                              context
                                  .read<EventDetailsCubit>()
                                  .toggleSaveEvent();
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
