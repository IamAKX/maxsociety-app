import 'package:flutter/material.dart';
import 'package:maxsociety/screen/admin_controls/community_member_list.dart';
import 'package:maxsociety/screen/admin_controls/create_flat.dart';
import 'package:maxsociety/screen/admin_controls/flat_screen.dart';
import 'package:maxsociety/screen/admin_controls/society_details.dart';
import 'package:maxsociety/screen/admin_controls/society_member_list.dart';
import 'package:maxsociety/screen/society/society_menu_model.dart';

import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';

class AdminControlsScreen extends StatefulWidget {
  const AdminControlsScreen({super.key});
  static const String routePath = '/adminControls';
  @override
  State<AdminControlsScreen> createState() => _AdminControlsScreenState();
}

class _AdminControlsScreenState extends State<AdminControlsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Admin Controls'),
      ),
      body: getBody(context),
    );
  }

  List<SocietyMenuModel> menuItemList = [
    SocietyMenuModel(
        icon: Icons.person_add_alt_outlined,
        navigatorRoute: SocietyMemberScreen.routePath,
        title: 'Society Member'),
    SocietyMenuModel(
        icon: Icons.room_preferences_outlined,
        navigatorRoute: FlatScreen.routePath,
        title: 'Create Flat'),
    SocietyMenuModel(
        icon: Icons.home_work_outlined,
        navigatorRoute: SocietyDetails.routePath,
        title: 'Society Details'),
    SocietyMenuModel(
        icon: Icons.person_pin_outlined,
        navigatorRoute: CommunityMemberListScreen.routePath,
        title: 'Committee Member'),
    SocietyMenuModel(
      icon: Icons.receipt_long_rounded,
      navigatorRoute: '',
      title: 'Report',
    ),
  ];

  getBody(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(menuItemList[index].icon),
            title: Text(menuItemList[index].title!,
                style: Theme.of(context).textTheme.titleMedium),
            trailing: const Icon(
              Icons.chevron_right_outlined,
              color: hintColor,
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(menuItemList[index].navigatorRoute!);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: dividerColor,
            endIndent: defaultPadding,
            indent: defaultPadding * 3,
            height: 1,
          );
        },
        itemCount: menuItemList.length);
  }
}
