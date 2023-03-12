import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxsociety/main.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/screen/login/login_screen.dart';
import 'package:maxsociety/screen/profile/family_screen.dart';
import 'package:maxsociety/screen/profile/profile_detail_update.dart';
import 'package:maxsociety/screen/profile/profile_menu_model.dart';
import 'package:maxsociety/screen/profile/vehicle_screen.dart';
import 'package:maxsociety/service/auth_service.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/preference_key.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../service/storage_service.dart';
import '../../util/enums.dart';
import '../../util/helper_methods.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? userProfile;
  bool isImageUploading = false;
  late ApiProvider _api;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadUser(),
    );
  }

  loadUser() {
    userProfile =
        UserProfile.fromJson(prefs.getString(PreferenceKey.user) ?? '');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

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
                    child: CachedNetworkImage(
                      imageUrl: userProfile?.imagePath ?? '',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/image/user_square.jpg',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed:
                        isImageUploading || _api.status == ApiStatus.loading
                            ? null
                            : () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image != null) {
                                  File imageFile = File(image.path);
                                  SnackBarService.instance.showSnackBarInfo(
                                      'Uploading file, please wait');
                                  setState(() {
                                    isImageUploading = true;
                                  });
                                  String imageUrl =
                                      await StorageService.uploadEventImage(
                                    imageFile,
                                    getFileName(imageFile),
                                    StorageFolders.profileImage.name,
                                  );

                                  setState(() {
                                    isImageUploading = false;
                                  });
                                  userProfile?.imagePath = imageUrl;
                                  _api.updateUser(userProfile!).then((value) {
                                    log('value : ${value.toString()}');
                                    log('status : ${_api.status.toString()}');
                                    userProfile?.imagePath = imageUrl;

                                    prefs.setString(PreferenceKey.user,
                                        userProfile?.toJson() ?? '');
                                    log(prefs.getString(PreferenceKey.user)!);
                                    loadUser();
                                  });
                                }
                              },
                    child: isImageUploading || _api.status == ApiStatus.loading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Edit Picture'),
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
                      userProfile?.userName ?? '',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    Text(
                      userProfile?.email ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '${userProfile?.flats?.tower ?? ''}   •   Flat ${userProfile?.flats?.flatNo ?? ''}',
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
                        .pushNamed(menuItems[index].navigatorRoute!)
                        .then((value) => loadUser());
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
