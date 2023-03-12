import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/screen/profile/add_family_screen.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key});
  static const String routePath = '/familyScreen';

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;
  List<UserProfile> familyList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadFamily(),
    );
  }

  loadFamily() async {
    _api.getMembersByFlatNo(userProfile.flats?.flatNo ?? '').then((value) {
      setState(() {
        familyList = value.data ?? [];
        familyList.removeWhere(
            (element) => element.relationship == userDefaultRelationship);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Family'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddFamilyMemberScreen.routePath)
                  .then(
                    (value) => loadFamily(),
                  );
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
              child: CachedNetworkImage(
                imageUrl: familyList.elementAt(index).imagePath ?? '',
                width: homePageUserIconSize * 1.2,
                height: homePageUserIconSize * 1.2,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/image/user.png',
                  width: homePageUserIconSize * 1.2,
                  height: homePageUserIconSize * 1.2,
                ),
              ),
              // child: Image.asset(
              //   'assets/image/user.png',
              //   width: homePageUserIconSize * 1.2,
              //   height: homePageUserIconSize * 1.2,
              // ),
            ),
            title: Text(
              '${familyList.elementAt(index).userName}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              '${familyList.elementAt(index).relationship}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    launchUrl(Uri.parse(
                        'tel:${familyList.elementAt(index).mobileNo}'));
                  },
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    _api
                        .deleteUser(familyList.elementAt(index).userId ?? '')
                        .then((value) => loadFamily());
                  },
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
        itemCount: familyList.length);
  }
}
