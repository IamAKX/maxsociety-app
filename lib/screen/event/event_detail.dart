import 'package:flutter/material.dart';
import 'package:maxsociety/widget/heading.dart';

import '../../util/colors.dart';
import '../../util/messages.dart';
import '../../util/theme.dart';
import 'dart:math' as math;

class EventDetail extends StatefulWidget {
  const EventDetail({super.key, required this.isTextOnly});
  final bool isTextOnly;
  static const String routePath = '/eventDetail';

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Details'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      children: [
        widget.isTextOnly
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(defaultPadding),
                color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                    .withOpacity(0.2),
                child: Text(
                  loremIpsumText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              )
            : Image.asset(
                'assets/banner/login_banner.jpeg',
                fit: BoxFit.cover,
              ),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(homePageUserIconSize),
                // child: CachedNetworkImage(
                //   imageUrl: userProfile.profileImage ?? '',
                //   width: homePageUserIconSize,
                //   height: homePageUserIconSize,
                //   fit: BoxFit.cover,
                //   placeholder: (context, url) =>
                //       const Center(child: CircularProgressIndicator()),
                //   errorWidget: (context, url, error) => Image.asset(
                //     'assets/image/user.png',
                //     width: homePageUserIconSize,
                //     height: homePageUserIconSize,
                //   ),
                // ),
                child: Image.asset(
                  'assets/image/user.png',
                  width: homePageUserIconSize,
                  height: homePageUserIconSize,
                ),
              ),
              const SizedBox(
                width: defaultPadding / 2,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'John Doe',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'A - 101',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '12 min ago',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
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
                '12 Feb,2023 at 8:30 PM',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
        if (!widget.isTextOnly) ...{
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              loremIpsumText,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        }
      ],
    );
  }
}
