import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:maxsociety/model/circular_model.dart';
import 'package:maxsociety/screen/event/event_detail.dart';
import 'package:maxsociety/util/datetime_formatter.dart';

import '../../util/colors.dart';
import '../../util/messages.dart';
import '../../util/theme.dart';

class EventWithImage extends StatelessWidget {
  final CircularModel circular;
  const EventWithImage({
    super.key,
    required this.circular,
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
                  child: CachedNetworkImage(
                    imageUrl: circular.updatedBy?.imagePath ?? '',
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
                      circular.updatedBy?.userName ?? '',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      '${circular.updatedBy?.flats?.tower} - ${circular.updatedBy?.flats?.flatNo}  •  ${eventTimesAgo(circular.updatedOn ?? '')}',
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
              Navigator.of(context).pushNamed(EventDetail.routePath,
                  arguments: circular.circularId.toString());
            },
            child: CachedNetworkImage(
              imageUrl: circular.circularImages?.first.imageUrl ?? '',
              fit: BoxFit.fitWidth,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Image.asset(
                'assets/image/404.jpg',
              ),
            ),
          ),
          if (circular.showEventDate ?? false)
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
                    eventDateToDateTime(circular.eventDate ?? ''),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(
                left: defaultPadding / 2,
                right: defaultPadding / 2,
                bottom: defaultPadding / 2),
            child: Text(
              circular.circularText ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
