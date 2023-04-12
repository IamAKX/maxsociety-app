import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/model/list/visitor_record_list_model.dart';
import 'package:maxsociety/util/enums.dart';
import 'package:maxsociety/util/helper_methods.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../model/visitors_record_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/datetime_formatter.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';

class VisitorLogScreen extends StatefulWidget {
  const VisitorLogScreen({super.key});

  @override
  State<VisitorLogScreen> createState() => _VisitorLogScreenState();
}

class _VisitorLogScreenState extends State<VisitorLogScreen> {
  UserProfile? userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;
  List<VisiorsRecordModel> record = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadRecords(),
    );
  }

  loadRecords() async {
    await _api.getAllVisitorRecord().then((value) {
      record = value.gateKeepRequests ?? [];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Visitor\'s Log'),
        actions: [
          TextButton(
            onPressed: () => loadRecords(),
            child: const Text('Refresh'),
          )
        ],
      ),
      body: getBody(),
    );
  }

  getBody() {
    if (_api.status == ApiStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (record.isEmpty) {
      return Center(
        child: Text(
          'No Visitor history found',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(record.elementAt(index).visitorName ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Guard : ${record.elementAt(index).guardName}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  eventDateToDateTime(
                      record.elementAt(index).gkReqInitTime ?? ''),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            trailing: Text(
              record.elementAt(index).status ?? '',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: getCircularStatusColor(
                      record.elementAt(index).status ?? '')),
            ),
            onTap: () {
              AwesomeDialog(
                context: context,
                dialogType: getDialogType(record.elementAt(index).status ?? ''),
                animType: AnimType.bottomSlide,
                body: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        record.elementAt(index).status ?? '',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: getCircularStatusColor(
                                record.elementAt(index).status ?? '')),
                      ),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                      detailRow(
                          'Visitor', record.elementAt(index).visitorName ?? ''),
                      detailRow(
                          'Guard', record.elementAt(index).guardName ?? ''),
                      detailRow(
                        'Entry Time',
                        eventDateToDateTime(
                            record.elementAt(index).gkReqInitTime ?? ''),
                      ),
                      detailRow(
                        'Action Time',
                        eventDateToDateTime(
                            record.elementAt(index).gkReqActionTime ?? ''),
                      ),
                      const SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Text('Purpose',
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(record.elementAt(index).visitPurpose ?? '',
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(
                        height: defaultPadding,
                      ),
                    ],
                  ),
                ),
                autoDismiss: false,
                btnOkText: 'Okay',
                btnCancelColor: Colors.red,
                btnOkColor: primaryColor,
                onDismissCallback: (type) {},
                btnOkOnPress: () {
                  navigatorKey.currentState!.pop();
                },
              ).show();
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(
              color: dividerColor,
            ),
        itemCount: record.length);
  }

  DialogType getDialogType(String status) {
    if (status == NotificationStatus.APPROVED.name) return DialogType.success;
    if (status == NotificationStatus.REJECTED.name) return DialogType.error;
    return DialogType.info;
  }

  Row detailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
