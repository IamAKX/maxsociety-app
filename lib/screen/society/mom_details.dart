import 'package:flutter/material.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/widget/image_viewer.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/circular_model.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/helper_methods.dart';
import '../../util/messages.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';

class MomDetailScreen extends StatefulWidget {
  const MomDetailScreen({super.key, required this.meetingId});
  static const String routePath = '/momDetailScreen';
  final int meetingId;

  @override
  State<MomDetailScreen> createState() => _MomDetailScreenState();
}

class _MomDetailScreenState extends State<MomDetailScreen> {
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
    await _api.getCircularById(widget.meetingId.toString()).then((value) {
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
        title: Heading(title: 'MOM #${circular?.circularNo}'),
        actions: [
          if (isAdminUser())
            IconButton(
              onPressed: () {
                _api
                    .deleteCircular(circular?.circularId ?? 0)
                    .then((value) => Navigator.of(context).pop());
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            )
        ],
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
          'Held on ${eventDateToDate(circular?.eventDate ?? '')}',
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
        const SizedBox(height: defaultPadding),
        if (circular?.circularImages?.isNotEmpty ?? false) ...{
          Text(
            'Attachments',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: textColorDark),
          ),
          const SizedBox(height: defaultPadding / 2),
          Wrap(
            direction: Axis.horizontal,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(ImageViewer.routePath,
                      arguments:
                          circular?.circularImages?.first.imageUrl ?? '');
                },
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: dividerColor),
                  ),
                  child: const Icon(
                    Icons.file_present_outlined,
                    color: hintColor,
                    size: 50,
                  ),
                ),
              )
            ],
          ),
        }
      ],
    );
  }
}
