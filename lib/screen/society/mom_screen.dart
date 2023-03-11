import 'package:flutter/material.dart';
import 'package:maxsociety/screen/admin_controls/create_mom_screen.dart';
import 'package:maxsociety/screen/society/mom_details.dart';
import 'package:maxsociety/widget/heading.dart';

import '../../util/colors.dart';
import '../../util/messages.dart';

class MomScreen extends StatefulWidget {
  const MomScreen({super.key});
  static const String routePath = '/momScreen';

  @override
  State<MomScreen> createState() => _MomScreenState();
}

class _MomScreenState extends State<MomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(
          title: 'Minute Of Meeting',
          overrideFontSize: 28,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CreateMomScreen.routePath)
                  .then((value) {
                setState(() {});
              });
            },
            child: const Text('Create'),
          )
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Text('${index + 1}'),
            ),
            title: Text(
              loremIpsumText,
              maxLines: 2,
            ),
            subtitle: Text(
              'Held on $index Feb, 2023',
              maxLines: 2,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(MomDetailScreen.routePath, arguments: index + 1);
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: dividerColor,
          );
        },
        itemCount: 10);
  }
}
