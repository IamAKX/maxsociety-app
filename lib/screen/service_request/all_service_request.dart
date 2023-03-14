import 'package:flutter/material.dart';
import 'package:maxsociety/screen/service_request/service_request_details.dart';
import 'package:maxsociety/util/datetime_formatter.dart';
import 'package:maxsociety/util/helper_methods.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../main.dart';
import '../../model/circular_model.dart';
import '../../model/user_profile_model.dart';
import '../../service/api_service.dart';
import '../../service/snakbar_service.dart';
import '../../util/colors.dart';
import '../../util/constants.dart';
import '../../util/enums.dart';
import '../../util/messages.dart';
import '../../util/preference_key.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';

class AllServiceRequest extends StatefulWidget {
  const AllServiceRequest({super.key});
  static const String routePath = '/allServiceRequest';

  @override
  State<AllServiceRequest> createState() => _AllServiceRequestState();
}

class _AllServiceRequestState extends State<AllServiceRequest> {
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Heading(title: 'Service Request'),
          bottom: TabBar(
            tabs: const [
              Tab(
                text: 'Open',
              ),
              Tab(
                text: 'Closed',
              ),
            ],
            labelColor: textColorDark,
            unselectedLabelColor: hintColor,
            indicatorColor: primaryColor,
            indicator: MaterialIndicator(
              height: 5,
              topLeftRadius: 8,
              topRightRadius: 8,
              horizontalPadding: 50,
              tabPosition: TabPosition.bottom,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            serviceItems(circularList
                .where((element) =>
                    element.circularStatus == CircularStatus.OPEN.name)
                .toList()),
            serviceItems(circularList
                .where((element) =>
                    element.circularStatus == CircularStatus.CLOSED.name)
                .toList()),
          ],
        ),
      ),
    );
  }

  serviceItems(List<CircularModel> list) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ServiceRequestDetail.routePath,
                    arguments: list.elementAt(index).circularId)
                .then((value) => loadCirculars());
          },
          child: Card(
            margin: const EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              bottom: defaultPadding,
            ),
            color: background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  color: primaryColor.withOpacity(0.1),
                  child: Text(
                    list.elementAt(index).subject ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
                            list.elementAt(index).circularCategory ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            list.elementAt(index).circularStatus ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: getCircularStatusColor(
                                      list.elementAt(index).circularStatus ??
                                          ''),
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        ],
                      ),
                      const Spacer(),
                      Text(
                        eventTimesAgo(list.elementAt(index).updatedOn ?? ''),
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
        );
      },
    );
  }
}
