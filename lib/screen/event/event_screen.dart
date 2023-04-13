import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/main.dart';
import 'package:maxsociety/model/circular_model.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/screen/event/create_event.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/enums.dart';
import 'package:maxsociety/util/preference_key.dart';
import 'package:maxsociety/widget/actionbar_popup_menu.dart';
import 'package:provider/provider.dart';

import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/theme.dart';
import 'event_with_image.dart';
import 'event_without_image.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  UserProfile? userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;
  List<CircularModel> circularList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadCirculars(),
    );
  }

  loadCirculars() async {
    _api.getCircularsByCircularType(CircularType.CIRCULAR.name).then((value) {
      setState(() {
        circularList = value.data ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            (userProfile?.imagePath?.isEmpty ?? true)
                ? Image.asset(
                    'assets/image/user.png',
                    width: homePageUserIconSize,
                    height: homePageUserIconSize,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(homePageUserIconSize),
                    child: CachedNetworkImage(
                      imageUrl: userProfile?.imagePath ?? '',
                      width: homePageUserIconSize,
                      height: homePageUserIconSize,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        'assets/image/user.png',
                        width: homePageUserIconSize,
                        height: homePageUserIconSize,
                      ),
                    ),
                    // child: Image.asset(
                    //   'assets/image/demouser.jpeg',
                    //   width: homePageUserIconSize,
                    //   height: homePageUserIconSize,
                    // ),
                  ),
            const SizedBox(
              width: defaultPadding / 2,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hi ${userProfile?.userName?.split(' ')[0]}!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'Flat ${userProfile?.flats?.flatNo ?? ''}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CreateEventScreen.routePath)
                  .then((value) {
                loadCirculars();
              });
            },
            child: const Text('Create'),
          ),
          const ActionbarPopupMenu(),
        ],
      ),
      backgroundColor: dividerColor.withOpacity(0.4),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (_api.status == ApiStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_api.status == ApiStatus.failed) {
      return Center(
        child: Text(
          'No Event found',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    return ListView.builder(
      itemCount: circularList.length,
      itemBuilder: (context, index) {
        if (circularList.elementAt(index).circularImages?.isNotEmpty ?? false) {
          return EventWithImage(
            circular: circularList.elementAt(index),
            notifyParent: loadCirculars,
          );
        } else {
          return EventWithoutImage(
            circular: circularList.elementAt(index),
            notifyParent: loadCirculars,
          );
        }
      },
    );
  }
}
