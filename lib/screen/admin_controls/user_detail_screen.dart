import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/model/user_profile_model.dart';
import 'package:maxsociety/screen/profile/family_screen.dart';
import 'package:maxsociety/screen/profile/vehicle_screen.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:provider/provider.dart';

import '../../model/operation_detail_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key, required this.userId});
  final String userId;
  static const String routePath = '/userDetailScreen';

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  late ApiProvider _api;
  UserProfile? userProfile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadUserProfile(),
    );
  }

  loadUserProfile() async {
    _api.getUserById(widget.userId).then((value) {
      setState(() {
        userProfile = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'User Details'),
      ),
      body: getBody(context),
      backgroundColor: backgroundDark,
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        CachedNetworkImage(
          imageUrl: userProfile?.imagePath ?? '',
          // width: 120,
          // height: 300,
          fit: BoxFit.fitWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Image.asset(
            'assets/image/user_square.jpg',
            // width: 120,
            // height: 300,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: dividerColor,
            ),
            borderRadius: BorderRadius.circular(defaultPadding / 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'PROFILE',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              detailRow('Name', '${userProfile?.userName}'),
              detailRow('Phone', '${userProfile?.mobileNo}'),
              detailRow('Gender', '${userProfile?.gender}'),
              detailRow('DOB', eventDateToDate(userProfile?.dob ?? '')),
              detailRow('Email', '${userProfile?.email}'),
              detailRow('Family Member', '${userProfile?.familyMembersCount}'),
              detailRow(
                  'Vehicle', '${userProfile?.flats?.vehicles?.length ?? 0}'),
              detailRow('Designation', userProfile?.designation ?? '-'),
              detailRow('Category', userProfile?.category ?? '-'),
              // detailRow('Onboarded on',
              //     '${eventDateToDate(userProfile?.createdOn ?? '')}'),
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: dividerColor,
            ),
            borderRadius: BorderRadius.circular(defaultPadding / 4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FLAT',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              detailRow('Flat No', '${userProfile?.flats?.flatNo}'),
              detailRow('Block', '${userProfile?.flats?.tower}'),
              detailRow('Floor', '${userProfile?.flats?.floor}'),
              detailRow('Super Builtup Area',
                  '${userProfile?.flats?.buitlUpArea} sqft'),
              detailRow(
                  'Carpet Area', '${userProfile?.flats?.carpetArea} sqft'),
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.group_outlined),
          title: Text('View family members'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).pushNamed(
              FamilyScreen.routePath,
              arguments: OperationDetailModel(
                  allowEdit: false, flatNo: userProfile?.flats?.flatNo ?? ''),
            );
          },
        ),
        Container(
          color: dividerColor,
          width: double.infinity,
          height: 1,
        ),
        ListTile(
          tileColor: Colors.white,
          leading: Icon(Icons.car_crash_outlined),
          title: Text('View Vehicles'),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).pushNamed(
              VehicleScreen.routePath,
              arguments: OperationDetailModel(
                  allowEdit: false, flatNo: userProfile?.flats?.flatNo ?? ''),
            );
          },
        ),
      ],
    );
  }

  Row detailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ],
    );
  }
}
