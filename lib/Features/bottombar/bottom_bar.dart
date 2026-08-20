
import 'package:flutter/material.dart';
import 'package:graduation2/Features/Profile/presentation/pages/profile_page.dart';
import 'package:graduation2/Features/courses_enrollment/presentation/pages/courses_enroll_page.dart';
import 'package:graduation2/Features/home/presentation/home.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _Bottombar();
}

class _Bottombar extends State<Bottombar> {
  int selectedIndex = 0;

  final PageController _pageController = PageController();

  final List<Widget> pages = const [
    Home(),
    CourseEnrollPage(),
    ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),

      bottomNavigationBar: SlidingClippedNavBar.colorful(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        iconSize: 30,
        selectedIndex: selectedIndex,

        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });

          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },

        barItems: [

          BarItem(
            icon: Icons.home,

            title: 'Home',
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: .55),
          ),


          BarItem(
            icon: Icons.slow_motion_video_sharp,
            title: 'Courses',
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: .55),
          ),

          BarItem(
            icon: Icons.person,
            title: 'Profile',
            activeColor: Theme.of(context).colorScheme.primary,
            inactiveColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: .55),
          ),
        ],
      ),
    );
  }
}
