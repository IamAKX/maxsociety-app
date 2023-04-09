import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/screen/security_guard/add_visitor_screen.dart';
import 'package:maxsociety/screen/security_guard/visitor_log_screen.dart';

import '../../service/db_service.dart';
import '../profile/profile_screen.dart';

class GuardMainContainer extends StatefulWidget {
  const GuardMainContainer({super.key});
  static const String routePath = '/guardMainContainer';
  @override
  State<GuardMainContainer> createState() => _GuardMainContainerState();
}

class _GuardMainContainerState extends State<GuardMainContainer> {
  int _selectedIndex = 0;
  getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const AddVisitorScreen();
      case 1:
        return const VisitorLogScreen();
      case 2:
        return const ProfileScreen();

      default:
        return const AddVisitorScreen();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadMetaData();
  }

  loadMetaData() async {
    await DBService.instance.getAppMetadata();
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
            icon: const Icon(Icons.co_present_outlined),
            title: const Text('Visitor'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.history),
            title: const Text('Log'),
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
