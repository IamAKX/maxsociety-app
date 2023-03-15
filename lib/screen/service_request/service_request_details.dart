import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/util/enums.dart';
import 'package:maxsociety/util/helper_methods.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/circular_model.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/messages.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';

class ServiceRequestDetail extends StatefulWidget {
  const ServiceRequestDetail({super.key, required this.reqId});
  final int reqId;
  static const String routePath = '/serviceRequestDetail';

  @override
  State<ServiceRequestDetail> createState() => _ServiceRequestDetailState();
}

class _ServiceRequestDetailState extends State<ServiceRequestDetail> {
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
    await _api.getCircularById(widget.reqId.toString()).then((value) {
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
        title: Heading(title: 'Request #${circular?.circularNo ?? ''}'),
        actions: [
          TextButton(
            onPressed: (_api.status == ApiStatus.loading)
                ? null
                : () async {
                    circular?.circularStatus =
                        (circular?.circularStatus ?? '') ==
                                CircularStatus.OPEN.name
                            ? CircularStatus.CLOSED.name
                            : CircularStatus.OPEN.name;

                    await _api.updateCircular(circular!).then((value) {
                      if (value) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
            child: Text(
                (circular?.circularStatus ?? '') == CircularStatus.OPEN.name
                    ? 'Close'
                    : 'Open'),
          )
        ],
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
          'Failed to data',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }
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
          'Posted on ${eventDateToDate(circular?.createdOn ?? '')}',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: textColorLight),
        ),
        Text(
          circular?.circularStatus ?? '',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: getCircularStatusColor(circular?.circularStatus ?? ''),
                fontWeight: FontWeight.bold,
              ),
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
        Text(
          'Images Attached',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: defaultPadding / 2),
        CachedNetworkImage(
          imageUrl: circular?.circularImages?.first.imageUrl ?? '',
          fit: BoxFit.fitWidth,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Image.asset(
            'assets/image/404.jpg',
          ),
        ),
      ],
    );
  }
}
