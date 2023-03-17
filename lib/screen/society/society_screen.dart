import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maxsociety/main.dart';
import 'package:maxsociety/model/society_model.dart';
import 'package:maxsociety/screen/society/about_society.dart';
import 'package:maxsociety/screen/admin_controls/admin_controls_screen.dart';
import 'package:maxsociety/screen/society/emergency_contact.dart';
import 'package:maxsociety/screen/society/govt_circular.dart';
import 'package:maxsociety/screen/society/mom_screen.dart';
import 'package:maxsociety/screen/society/society_menu_model.dart';
import 'package:maxsociety/screen/society/society_rule_screen.dart';
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

class SocietyScreen extends StatefulWidget {
  const SocietyScreen({super.key});

  @override
  State<SocietyScreen> createState() => _SocietyScreenState();
}

class _SocietyScreenState extends State<SocietyScreen> {
  bool isImageUploading = false;
  late ApiProvider _api;
  SocietyModel? societyModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadSociety(),
    );
  }

  loadSociety() async {
    societyModel = await ApiProvider.instance.getSociety();
    prefs.setString(PreferenceKey.society, societyModel?.toJson() ?? '');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);

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
                    // image: DecorationImage(
                    //   fit: BoxFit.cover,
                    //   image: AssetImage(
                    //     'assets/banner/login_banner.jpeg',
                    //   ),
                    // ),
                  ),
                  height: 230.0,
                  child: (societyModel?.societyDetails?.imagePath?.isEmpty ??
                          true)
                      ? Container()
                      : CachedNetworkImage(
                          imageUrl:
                              societyModel?.societyDetails?.imagePath ?? '',
                          width: double.infinity,
                          height: 230.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/image/404.jpg',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            height: 230.0,
                          ),
                        ),
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
                ),
                if (isAdminUser())
                  Positioned(
                    bottom: defaultPadding,
                    right: 2,
                    child: IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          File imageFile = File(image.path);
                          SnackBarService.instance
                              .showSnackBarInfo('Uploading file, please wait');
                          setState(() {
                            isImageUploading = true;
                          });
                          String imageUrl =
                              await StorageService.uploadEventImage(
                            imageFile,
                            getFileName(imageFile),
                            StorageFolders.societyBanner.name,
                          );

                          setState(() {
                            isImageUploading = false;
                          });
                          societyModel?.societyDetails?.imagePath = imageUrl;
                          await _api.updateSociety(societyModel!).then((value) {
                            if (value) {
                              societyModel?.societyDetails?.imagePath =
                                  imageUrl;
                              prefs.setString(PreferenceKey.society,
                                  societyModel?.toJson() ?? '');
                              loadSociety();
                            }
                          });
                        }
                      },
                      icon: isImageUploading || _api.status == ApiStatus.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            )
                          : const Icon(
                              Icons.add_photo_alternate,
                              color: textColorDark,
                              size: 30,
                            ),
                    ),
                  )
              ],
            ),
          ),
          Heading(
              title: 'Welcome to ${societyModel?.societyDetails?.societyName}'),
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
    if (isAdminUser())
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
