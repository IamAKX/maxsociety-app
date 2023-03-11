import 'package:flutter/material.dart';
import 'package:maxsociety/screen/profile/add_family_screen.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/widget/heading.dart';

import '../../util/colors.dart';
import '../../util/theme.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});
  static const String routePath = '/familyScreen';

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Family'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddFamilyMemberScreen.routePath);
            },
            child: Text(
              'Add Family',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
            ),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(homePageUserIconSize),
              // child: CachedNetworkImage(
              //   imageUrl: userProfile.profileImage ?? '',
              //   width: homePageUserIconSize,
              //   height: homePageUserIconSize,
              //   fit: BoxFit.cover,
              //   placeholder: (context, url) =>
              //       const Center(child: CircularProgressIndicator()),
              //   errorWidget: (context, url, error) => Image.asset(
              //     'assets/image/user.png',
              //     width: homePageUserIconSize,
              //     height: homePageUserIconSize,
              //   ),
              // ),
              child: Image.asset(
                'assets/image/user.png',
                width: homePageUserIconSize * 1.2,
                height: homePageUserIconSize * 1.2,
              ),
            ),
            title: Text(
              'John Doe $index',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              relationshipList[index],
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.person_remove_alt_1_sharp,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
              endIndent: defaultPadding,
              indent: defaultPadding * 4,
            ),
        itemCount: 4);
  }
}
