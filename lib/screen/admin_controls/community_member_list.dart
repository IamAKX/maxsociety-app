import 'package:flutter/material.dart';
import 'package:maxsociety/screen/admin_controls/create_community_member.dart';

import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/custom_textfield.dart';
import '../../widget/heading.dart';

class CommunityMemberListScreen extends StatefulWidget {
  const CommunityMemberListScreen({super.key});
  static const String routePath = '/adminControls/communityMember';

  @override
  State<CommunityMemberListScreen> createState() =>
      _CommunityMemberListScreenState();
}

class _CommunityMemberListScreenState extends State<CommunityMemberListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(
          title: 'Committee Member',
          overrideFontSize: 25,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context)
                  .pushNamed(CreateCommitteeMember.routePath)
                  .then((value) {
                setState(() {});
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
                        'assets/image/demouser.jpeg',
                        width: homePageUserIconSize,
                        height: homePageUserIconSize,
                      ),
                    ),
                    title: Text(
                      'User$index Surname',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Text(
                      'Secretary  •  user$index@email.com',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.call_outlined,
                            color: Colors.green,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
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
              itemCount: 7),
        ),
      ],
    );
  }
}
