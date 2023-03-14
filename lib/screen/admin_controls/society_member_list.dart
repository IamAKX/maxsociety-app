import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/screen/admin_controls/create_society_member.dart';
import 'package:maxsociety/screen/admin_controls/user_detail_screen.dart';
import 'package:maxsociety/widget/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/list/user_list_model.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';

class SocietyMemberScreen extends StatefulWidget {
  const SocietyMemberScreen({super.key});
  static const String routePath = '/adminControls/SocietyMember';

  @override
  State<SocietyMemberScreen> createState() => _SocietyMemberScreenState();
}

class _SocietyMemberScreenState extends State<SocietyMemberScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  late ApiProvider _api;
  List<UserProfile> mainUserList = [];
  List<UserProfile> userList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadUsers(),
    );
  }

  loadUsers() async {
    UserListModel model = await _api.getUsersByRole('MEMBER');
    mainUserList = model.data ?? [];
    userList.clear();
    userList.addAll(mainUserList);

    _searchCtrl.addListener(() {
      setState(() {
        if (_searchCtrl.text.isEmpty) {
          userList.clear();
          userList.addAll(mainUserList);
        } else {
          userList = mainUserList
              .where(
                (user) => (user.userName!.toLowerCase()).contains(
                  _searchCtrl.text.toLowerCase(),
                ),
              )
              .toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Society Members'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context)
                  .pushNamed(CreateSocietyMemberScreen.routePath)
                  .then((value) {
                loadUsers();
              });
            },
            child: const Text('Create'),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          child: CustomTextField(
            hint: 'Search',
            controller: _searchCtrl,
            keyboardType: TextInputType.name,
            obscure: false,
            icon: Icons.search,
          ),
        ),
        Expanded(
          child: ListView.separated(
              itemBuilder: (context, index) => ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(homePageUserIconSize),
                      child: CachedNetworkImage(
                        imageUrl: userList.elementAt(index).imagePath ?? '',
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
                    title: Text(
                      userList.elementAt(index).userName ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      '${userList.elementAt(index).flats?.flatNo}  •  ${userList.elementAt(index).email}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            launchUrl(Uri.parse(
                                'tel:${userList.elementAt(index).mobileNo}'));
                          },
                          icon: const Icon(
                            Icons.call_outlined,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                                UserDetail.routePath,
                                arguments: userList.elementAt(index).userId);
                          },
                          icon: const Icon(
                            Icons.info_outline,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
              separatorBuilder: (context, index) => const Divider(
                    color: dividerColor,
                    endIndent: defaultPadding,
                    indent: defaultPadding * 3,
                    height: 1,
                  ),
              itemCount: userList.length),
        ),
      ],
    );
  }
}
