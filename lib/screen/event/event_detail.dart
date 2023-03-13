import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/model/circular_model.dart';
import 'package:maxsociety/util/api.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/messages.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';
import 'dart:math' as math;

class EventDetail extends StatefulWidget {
  const EventDetail({
    super.key,
    required this.circularId,
  });
  static const String routePath = '/eventDetail';
  final String circularId;

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  bool isTextOnly = false;
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
    await _api.getCircularById(widget.circularId).then((value) {
      setState(() {
      
        circular = value;
        isTextOnly = circular?.circularImages?.isEmpty ?? true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Details'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    if (_api.status == ApiStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_api.status == ApiStatus.failed) {
      return Center(
        child: Text(
          'Failed to load event',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
    return ListView(
      children: [
        isTextOnly
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(defaultPadding),
                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(0.2),
                child: Text(
                  circular?.circularText ?? '',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              )
            : CachedNetworkImage(
                imageUrl: circular?.circularImages?.first.imageUrl ?? '',
                fit: BoxFit.fitWidth,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/image/404.jpg',
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(homePageUserIconSize),
                child: CachedNetworkImage(
                  imageUrl: circular?.updatedBy?.imagePath ?? '',
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
                //   'assets/image/user.png',
                //   width: homePageUserIconSize,
                //   height: homePageUserIconSize,
                // ),
              ),
              const SizedBox(
                width: defaultPadding / 2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    circular?.updatedBy?.userName ?? '',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    '${circular?.updatedBy?.flats?.tower} - ${circular?.updatedBy?.flats?.flatNo}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                eventTimesAgo(circular?.updatedOn ?? ''),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        if (circular?.showEventDate ?? false) ...{
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Text(
              'Scheduled Time'.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: hintColor,
                  size: 20,
                ),
                const SizedBox(
                  width: defaultPadding / 2,
                ),
                Text(
                  eventDateToDateTime(circular?.updatedOn ?? ''),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        },
        if (!isTextOnly) ...{
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              circular?.circularText ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        }
      ],
    );
  }
}
