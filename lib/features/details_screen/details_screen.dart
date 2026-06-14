import 'package:event_hub/features/details_screen/views/InfoItem.dart';
import 'package:flutter/material.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

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
                  height: 260 ,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/event_cover.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 70, 24, 110),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'International Band\nMusic Concert',
                          style: TextStyle(
                            fontSize: 34,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 24),

                        const InfoItem(
                          icon: Icons.calendar_month,
                          title: '14 December, 2021',
                          subtitle: 'Tuesday, 4:00PM - 9:00PM',
                        ),
                        const SizedBox(height: 16),

                        const InfoItem(
                          icon: Icons.location_on,
                          title: 'Gala Convention Center',
                          subtitle: '36 Guild Street London, UK',
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                'assets/images/organizer.png',
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ashfak Sayem',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Organizer',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF747688),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Follow',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        const Text(
                          'About Event',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Enjoy your favorite dish and a lovely your friends and family '
                              'and have a great time. Food from local food trucks will be '
                              'available for purchase.Enjoy your favorite dish and a lovely your friends and family '
                              'and have a great time. Food from local food trucks will be '
                              'available for purchase.Enjoy your favorite dish and a lovely your friends and family '
                              'and have a great time. Food from local food trucks will be '
                              'available for purchase.Enjoy your favorite dish and a lovely your friends and family '
                              'and have a great time. Food from local food trucks will be '
                              'available for purchase.Enjoy your favorite dish and a lovely your friends and family '
                              'and have a great time. Food from local food trucks will be '
                              'available for purchase.',
                          style: TextStyle(
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
            top: 225,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                  SizedBox(
                    width: 92,
                    height: 34,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        avatar('assets/images/person1.png', 0),
                        avatar('assets/images/person2.png', 22),
                        avatar('assets/images/person3.png', 44),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+20 Going',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BUY TICKET \$120',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 12),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget avatar(String path, double left) {
    return Positioned(
      left: left,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 2),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.asset(
            path,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}