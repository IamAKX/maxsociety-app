import 'package:flutter/material.dart';
import 'package:maxsociety/screen/service_request/service_request_details.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../util/colors.dart';
import '../../util/constants.dart';
import '../../util/messages.dart';
import '../../util/theme.dart';
import '../../widget/heading.dart';

class AllServiceRequest extends StatefulWidget {
  const AllServiceRequest({super.key});
  static const String routePath = '/allServiceRequest';

  @override
  State<AllServiceRequest> createState() => _AllServiceRequestState();
}

class _AllServiceRequestState extends State<AllServiceRequest> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Heading(title: 'Service Request'),
          bottom: TabBar(
            tabs: const [
              Tab(
                text: 'Pending',
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
            pendingSerice(false),
            pendingSerice(true),
          ],
        ),
      ),
    );
  }

  pendingSerice(bool isPending) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(ServiceRequestDetail.routePath,
                arguments: index + 1);
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
                    loremIpsumText,
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
                            serviceRequestCategories[0],
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          (isPending)
                              ? Text(
                                  'Closed',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                )
                              : Text(
                                  'Pending',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        color: Colors.amber,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '$index days ago',
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
