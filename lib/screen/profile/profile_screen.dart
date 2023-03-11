import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maxsociety/screen/login/login_screen.dart';
import 'package:maxsociety/screen/profile/family_screen.dart';
import 'package:maxsociety/screen/profile/profile_detail_update.dart';
import 'package:maxsociety/screen/profile/profile_menu_model.dart';
import 'package:maxsociety/screen/profile/vehicle_screen.dart';
import 'package:maxsociety/service/auth_service.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Profile'),
      ),
      body: getBody(context),
    );
  }

  List<ProfileMenuModel> menuItems = [
    ProfileMenuModel(
      icon: Icons.person_outline,
      title: 'Profile Details',
      navigatorRoute: ProfileDetailUpdateScreen.routePath,
    ),
    ProfileMenuModel(
      icon: Icons.car_crash_outlined,
      title: 'Vehicle',
      navigatorRoute: VehicleScreen.routePath,
    ),
    ProfileMenuModel(
      icon: Icons.group_outlined,
      title: 'Family',
      navigatorRoute: FamilyScreen.routePath,
    ),
  ];

  getBody(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(defaultPadding),
                    child: Image.asset(
                      'assets/image/demouser.jpeg',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Edit Picture'),
                  )
                ],
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'John Doe',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      'john.doe@email.com',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      'Block A   •   Flat 105',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: defaultPadding / 2,
                    ),
                    const Divider(
                      color: dividerColor,
                      indent: defaultPadding,
                      endIndent: defaultPadding,
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: defaultPadding / 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '4',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                'Family',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: defaultPadding * 2,
                          color: dividerColor,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '2',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Text(
                                'Vehicle',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(menuItems[index].icon),
                  title: Text(menuItems[index].title!,
                      style: Theme.of(context).textTheme.titleMedium),
                  trailing: const Icon(
                    Icons.chevron_right_outlined,
                    color: hintColor,
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(menuItems[index].navigatorRoute!);
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
              itemCount: menuItems.length),
        ),
        ListTile(
          leading: const Icon(
            Icons.logout_outlined,
            color: Colors.red,
          ),
          title: Text(
            'Log out',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.red,
                ),
          ),
          onTap: () async => await AuthProvider.instance.logoutUser().then(
                (value) => Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routePath, (route) => false),
              ),
        )
      ],
    );
  }
}
