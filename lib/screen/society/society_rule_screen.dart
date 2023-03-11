import 'package:flutter/material.dart';
import 'package:maxsociety/screen/admin_controls/create_rule_screen.dart';
import 'package:maxsociety/screen/society/society_rule_detail.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/messages.dart';
import 'package:maxsociety/widget/heading.dart';

class SocietyRuleScreen extends StatefulWidget {
  const SocietyRuleScreen({super.key});
  static const String routePath = '/societyRuleScreen';

  @override
  State<SocietyRuleScreen> createState() => _SocietyRuleScreenState();
}

class _SocietyRuleScreenState extends State<SocietyRuleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Society Rules'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(CreateRuleScreen.routePath)
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
              'Effected from $index Feb, 2023',
              maxLines: 2,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).pushNamed(
                  SocietyRuleDetailsScreen.routePath,
                  arguments: index + 1);
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
