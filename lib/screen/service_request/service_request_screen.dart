import 'package:flutter/material.dart';
import 'package:maxsociety/screen/service_request/all_service_request.dart';
import 'package:maxsociety/screen/service_request/create_service_request.dart';
import 'package:maxsociety/screen/service_request/service_request_details.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/constants.dart';
import 'package:maxsociety/util/messages.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';

class ServiceRequestScreen extends StatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  State<ServiceRequestScreen> createState() => _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends State<ServiceRequestScreen> {
  @override
  Widget build(BuildContext context) {
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
                  Navigator.of(context).pushNamed(AllServiceRequest.routePath);
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
            itemCount: 5,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      ServiceRequestDetail.routePath,
                      arguments: index + 1);
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
                              loremIpsumText,
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
                                    '${serviceRequestCategories[index]}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  (index % 2 == 0)
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
                ),
              );
            },
          ),
        ),
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
                  Navigator.of(context).pushNamed(CreateServiceScreen.routePath,
                      arguments: serviceRequestCategories[index]);
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
