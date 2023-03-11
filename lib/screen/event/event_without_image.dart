import 'package:flutter/material.dart';

import '../../util/colors.dart';
import '../../util/messages.dart';
import '../../util/theme.dart';
import 'dart:math' as math;

import 'event_detail.dart';

class EventWithoutImage extends StatelessWidget {
  final int index;
  const EventWithoutImage({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: defaultPadding,
      margin: const EdgeInsets.only(
        left: defaultPadding,
        right: defaultPadding,
        top: defaultPadding / 2,
        bottom: defaultPadding / 2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultPadding / 2),
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
                      'User$index Doe',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'A - 10$index  •  1$index min ago',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right,
                  color: textColorLight,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(EventDetail.routePath, arguments: index % 3 == 0);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(defaultPadding),
              color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                  .withOpacity(0.2),
              child: Text(
                loremIpsumText,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                maxLines: 7,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding / 2),
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
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
