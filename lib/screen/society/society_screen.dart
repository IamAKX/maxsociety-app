import 'package:flutter/material.dart';
import 'package:maxsociety/screen/society/about_society.dart';
import 'package:maxsociety/screen/admin_controls/admin_controls_screen.dart';
import 'package:maxsociety/screen/society/emergency_contact.dart';
import 'package:maxsociety/screen/society/govt_circular.dart';
import 'package:maxsociety/screen/society/mom_screen.dart';
import 'package:maxsociety/screen/society/society_menu_model.dart';
import 'package:maxsociety/screen/society/society_rule_screen.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';

class SocietyScreen extends StatefulWidget {
  const SocietyScreen({super.key});

  @override
  State<SocietyScreen> createState() => _SocietyScreenState();
}

class _SocietyScreenState extends State<SocietyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 240,
            child: Stack(
              fit: StackFit.loose,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/banner/login_banner.jpeg',
                      ),
                    ),
                  ),
                  height: 230.0,
                ),
                Container(
                  height: 240.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white,
                      ],
                      stops: [0.0, 1.0],
                    ),
                  ),
                )
              ],
            ),
          ),
          Heading(title: 'Welcome to MaxSociety'),
          Expanded(
            child: Container(
              child: getBody(context),
            ),
          ),
        ],
      ),
    );
  }

  List<SocietyMenuModel> menuItemList = [
    SocietyMenuModel(
      icon: Icons.info_outline_rounded,
      title: 'About society',
      navigatorRoute: AboutSocietyScreen.routePath,
    ),
    SocietyMenuModel(
      icon: Icons.rule_outlined,
      title: 'Society rules',
      navigatorRoute: SocietyRuleScreen.routePath,
    ),
    SocietyMenuModel(
      icon: Icons.note_alt_outlined,
      title: 'Minute of meeting',
      navigatorRoute: MomScreen.routePath,
    ),
    SocietyMenuModel(
      icon: Icons.local_police_outlined,
      title: 'Goverment circular',
      navigatorRoute: GovermentCircularScreen.routePath,
    ),
    SocietyMenuModel(
      icon: Icons.contact_emergency_outlined,
      title: 'Emergency contacts',
      navigatorRoute: EmergencyContact.routePath,
    ),
    SocietyMenuModel(
      icon: Icons.admin_panel_settings_outlined,
      title: 'Admin Controls',
      navigatorRoute: AdminControlsScreen.routePath,
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
