import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/screen/event/event_screen.dart';
import 'package:maxsociety/screen/gallery/gallery_screen.dart';
import 'package:maxsociety/screen/profile/profile_screen.dart';
import 'package:maxsociety/screen/service_request/service_request_screen.dart';
import 'package:maxsociety/screen/society/society_screen.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});
  static const String routePath = '/mainContainer';

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  int _selectedIndex = 0;
  getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const EventScreen();
      case 1:
        return const GalleryScreen();
      case 2:
        return const SocietyScreen();
      case 3:
        return const ServiceRequestScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const EventScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getSelectedScreen(),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.event_note_outlined),
            title: const Text('Events'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.image_outlined),
            title: const Text('Gallery'),
          ),
          FlashyTabBarItem(
            icon: const Icon(
              Icons.home_work_outlined,
            ),
            title: const Text('Society'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.build_outlined),
            title: const Text('Service'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}
