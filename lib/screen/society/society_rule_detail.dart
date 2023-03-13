import 'package:flutter/material.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/messages.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/circular_model.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/datetime_formatter.dart';
import '../../util/preference_key.dart';

class SocietyRuleDetailsScreen extends StatefulWidget {
  const SocietyRuleDetailsScreen({super.key, required this.ruleId});
  static const String routePath = '/societyRuleDetailsScreen';
  final int ruleId;

  @override
  State<SocietyRuleDetailsScreen> createState() =>
      _SocietyRuleDetailsScreenState();
}

class _SocietyRuleDetailsScreenState extends State<SocietyRuleDetailsScreen> {
  CircularModel? circular;

  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
  late ApiProvider _api;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => loadCircular(),
    );
  }

  loadCircular() async {
    await _api.getCircularById(widget.ruleId.toString()).then((value) {
      setState(() {
        circular = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Rule #${circular?.circularNo}'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          circular?.subject ?? '',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          'Effected from ${eventDateToDate(circular?.eventDate ?? '')}',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: textColorLight),
        ),
        const SizedBox(height: defaultPadding),
        Text(
          circular?.circularText ?? '',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: textColorLight),
        ),
        const SizedBox(height: defaultPadding / 2),
        Text(
          'Order by,\nMax Society Committee',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: textColorDark),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
