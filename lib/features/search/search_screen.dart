import 'package:event_hub/features/search/views/SearchCard.dart';
import 'package:event_hub/utill/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/navigation/AppRoutes.dart';
import 'cubit/search_cubit.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context.read<SearchCubit>().onQueryChanged(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      child: MyTextField(controller: _controller),
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
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitial) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search,
                              size: 64,
                              color: Color(0xFFB8B8D2),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Search for events, artists,\nvenues and more',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF747688),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is SearchLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is SearchError) {
                      return Center(
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (state is! SearchLoaded) {
                      return const SizedBox.shrink();
                    }

                    if (state.results.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 64,
                              color: Color(0xFFB8B8D2),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No events found.\nTry a different keyword.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF747688),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: state.results.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final event = state.results[index];
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

  String formatDate(String? date, String? time) {
    if (date == null) return '';
    try {
      final parts = date.split('-');
      final months = [
        '', 'JAN', 'FEB','MAR', 'APR', 'MAY', 'JUN',
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