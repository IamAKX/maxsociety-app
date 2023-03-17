import 'package:flutter/material.dart';
import 'package:maxsociety/service/report_generator_service.dart';

import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';
import '../society/society_menu_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  static const String routePath = '/reportPath';

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;

    return Scaffold(
      appBar: AppBar(
        title: Heading(
          title: 'Reports',
          overrideFontSize: 28,
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text('Circular Report',
              style: Theme.of(context).textTheme.titleMedium),
          trailing: const Icon(
            Icons.chevron_right_outlined,
            color: hintColor,
          ),
          onTap: () async {
            await ReportGeneratorProvider.instance.generateCircularReport();
          },
        ),
        const Divider(
          color: textColorDark,
        ),
        ListTile(
          title: Text('Service Request Report',
              style: Theme.of(context).textTheme.titleMedium),
          trailing: const Icon(
            Icons.chevron_right_outlined,
            color: hintColor,
          ),
          onTap: () async {
            await ReportGeneratorProvider.instance
                .generateServiceRequestReport();
          },
        ),
        const Divider(
          color: textColorDark,
        ),
        ListTile(
          title: Text('Complaints Report',
              style: Theme.of(context).textTheme.titleMedium),
          trailing: const Icon(
            Icons.chevron_right_outlined,
            color: hintColor,
          ),
          onTap: () async {
            await ReportGeneratorProvider.instance.generateComplaintReport();
          },
        ),
        const Divider(
          color: textColorDark,
        ),
        ListTile(
          title: Text('Society Members',
              style: Theme.of(context).textTheme.titleMedium),
          trailing: const Icon(
            Icons.chevron_right_outlined,
            color: hintColor,
          ),
          onTap: () async {
            await ReportGeneratorProvider.instance.generateCircularReport();
          },
        ),
        const Divider(
          color: textColorDark,
        ),
        ListTile(
          title: Text('Tenants Members',
              style: Theme.of(context).textTheme.titleMedium),
          trailing: const Icon(
            Icons.chevron_right_outlined,
            color: hintColor,
          ),
          onTap: () async {
            await ReportGeneratorProvider.instance.generateCircularReport();
          },
        ),
        const Divider(
          color: textColorDark,
        ),
        ListTile(
          title: Text('Committee Members',
              style: Theme.of(context).textTheme.titleMedium),
          trailing: const Icon(
            Icons.chevron_right_outlined,
            color: hintColor,
          ),
          onTap: () async {
            await ReportGeneratorProvider.instance.generateCircularReport();
          },
        ),
      ],
    );
  }
}
