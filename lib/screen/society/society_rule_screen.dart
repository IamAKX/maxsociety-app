import 'package:flutter/material.dart';
import 'package:maxsociety/screen/admin_controls/create_rule_screen.dart';
import 'package:maxsociety/screen/society/society_rule_detail.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/helper_methods.dart';
import 'package:maxsociety/util/messages.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../model/circular_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/datetime_formatter.dart';
import '../../util/enums.dart';

class SocietyRuleScreen extends StatefulWidget {
  const SocietyRuleScreen({super.key});
  static const String routePath = '/societyRuleScreen';

  @override
  State<SocietyRuleScreen> createState() => _SocietyRuleScreenState();
}

class _SocietyRuleScreenState extends State<SocietyRuleScreen> {
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
    _api
        .getCircularsByCircularType(CircularType.SOCIETY_RULE.name)
        .then((value) {
      setState(() {
        circularList = value.data ?? [];
        circularList.sort(((a, b) => int.parse(a.circularNo ?? '0')
            .compareTo(int.parse(b.circularNo ?? '0'))));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Society Rules'),
        actions: [
          if (isAdminUser())
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CreateRuleScreen.routePath)
                    .then((value) {
                  loadCirculars();
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
    if (_api.status == ApiStatus.failed) {
      return Center(
        child: Text(
          'No Society Rule found',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: primaryColor.withOpacity(0.1),
              child: Text('${circularList.elementAt(index).circularNo}'),
            ),
            title: Text(
              circularList.elementAt(index).subject ?? '',
              maxLines: 2,
            ),
            subtitle: Text(
              'Effected from ${eventDateToDate(circularList.elementAt(index).eventDate ?? '')}',
              maxLines: 2,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(SocietyRuleDetailsScreen.routePath,
                      arguments: circularList.elementAt(index).circularId)
                  .then((value) => loadCirculars());
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            color: dividerColor,
          );
        },
        itemCount: circularList.length);
  }
}
