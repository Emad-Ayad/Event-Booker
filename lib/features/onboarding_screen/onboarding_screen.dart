import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController controller = PageController();
  int currentPage = 0;

  List<Map<String, String>> pages = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Explore Upcoming and Nearby Events ",
      "desc": " In publishing and graphic design, Lorem is a placeholder text commonly."
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Web Have Modern Events Calendar Feature",
      "desc": " In publishing and graphic design, Lorem is a placeholder text commonly."
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "To Look Up More Events or Activities Nearby By Map",
      "desc": " In publishing and graphic design, Lorem is a placeholder text commonly."
    },
  ];


  void nextPage() {
    if (currentPage < pages.length - 1) {
      controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          itemCount: pages.length,
          itemBuilder: (context,index){
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 52.5,vertical: 15.5),
                  child: Image.asset(
                    pages[index]["image"]!,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        pages[index]["title"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        pages[index]["desc"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: (){},
                              child: Text("Skip",style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              )
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                pages.length,
                                (dot) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: currentPage == dot ? Colors.white : Colors.white70,
                                    shape: BoxShape.circle
                                  ),
                                )
                            ),
                          ),
                          TextButton(
                              onPressed: nextPage,
                              child: Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ) ,
    );
  }
}

