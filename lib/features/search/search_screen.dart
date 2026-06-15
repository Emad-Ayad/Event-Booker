import 'dart:async';

import 'package:event_hub/features/search/views/SearchCard.dart';
import 'package:event_hub/utill/my_text_field.dart';
import 'package:flutter/material.dart';

import '../../data/datasource/HomeRemoteDataSource.dart';
import '../../data/model/EventModel.dart';
import '../../data/repo/HomeRepo.dart';
import '../services/navigation/AppRoutes.dart';



class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final HomeRepo repo;
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<EventModel> results = [];
  bool isLoading = false;
  bool hasSearched = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    repo = HomeRepo(HomeRemoteDataSource());
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onSearchChanged);
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _controller.text.trim();

    if (query.isEmpty) {
      _debounce?.cancel();
      setState(() {
        results = [];
        hasSearched = false;
        errorMessage = null;
      });
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(query);
    });
  }

  Future<void> _search(String keyword) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      hasSearched = true;
    });

    try {
      final data = await repo.searchEvents(keyword);
      setState(() {
        results = data;
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
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, textAlign: TextAlign.center),
      );
    }

    if (!hasSearched) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search, size: 64, color: Color(0xFFB8B8D2)),
            SizedBox(height: 16),
            Text(
              'Search for events, artists,\nvenues and more',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF747688), fontSize: 15),
            ),
          ],
        ),
      );
    }

    if (results.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.event_busy, size: 64, color: Color(0xFFB8B8D2)),
            SizedBox(height: 16),
            Text(
              'No events found.\nTry a different keyword.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF747688), fontSize: 15),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final event = results[index];
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