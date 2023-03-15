import 'package:flutter/material.dart';
import 'package:maxsociety/screen/service_request/all_service_request.dart';
import 'package:maxsociety/screen/service_request/create_service_request.dart';
import 'package:maxsociety/screen/service_request/service_request_details.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/util/helper_methods.dart';
import 'package:maxsociety/util/messages.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../model/circular_model.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/enums.dart';
import '../../util/preference_key.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  UserProfile userProfile =
      UserProfile.fromJson(prefs.getString(PreferenceKey.user)!);
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
    await _api
        .getServiceRequestByFilter(CircularType.SERVICE_REQUEST.name)
        .then((value) {
      setState(() {
        circularList = value.data ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      backgroundColor: dividerColor.withOpacity(0.2),
      appBar: AppBar(
        title: Heading(title: 'Service Request'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (circularList.isNotEmpty) ...{
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent request',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AllServiceRequest.routePath)
                        .then((value) => loadCirculars());
                  },
                  child: const Text('View all'),
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 160,
            child: ListView.builder(
              itemCount: circularList.length > 5 ? 5 : circularList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(ServiceRequestDetail.routePath,
                            arguments: circularList.elementAt(index).circularId)
                        .then((value) => loadCirculars());
                  },
                  child: Card(
                    margin: const EdgeInsets.only(
                      left: defaultPadding,
                      right: defaultPadding,
                      bottom: defaultPadding,
                    ),
                    color: background,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              width: double.maxFinite,
                              padding: const EdgeInsets.all(defaultPadding / 2),
                              color: primaryColor.withOpacity(0.1),
                              child: Text(
                                circularList.elementAt(index).subject ?? '',
                                style: Theme.of(context).textTheme.bodyLarge,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(
                              defaultPadding / 2,
                            ),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      circularList
                                              .elementAt(index)
                                              .circularCategory ??
                                          '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      circularList
                                              .elementAt(index)
                                              .circularStatus ??
                                          '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            color: getCircularStatusColor(
                                              circularList
                                                      .elementAt(index)
                                                      .circularStatus ??
                                                  '',
                                            ),
                                            fontWeight: FontWeight.bold,
                                          ),
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  eventTimesAgo(
                                      circularList.elementAt(index).updatedOn ??
                                          ''),
                                ),
                                const Icon(
                                  Icons.chevron_right_outlined,
                                  color: hintColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        },
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          child: Text(
            'Create new request',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Container(
                width: double.infinity,
                height: 1,
                color: dividerColor,
              );
            },
            itemCount: serviceRequestCategories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(CreateServiceScreen.routePath,
                          arguments: serviceRequestCategories[index])
                      .then((value) => loadCirculars());
                },
                child: Container(
                  color: background,
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(serviceRequestCategories[index],
                          style: Theme.of(context).textTheme.titleMedium),
                      const Icon(
                        Icons.chevron_right_outlined,
                        color: hintColor,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
