import 'package:flutter/material.dart';

import '../../util/colors.dart';
import '../../util/messages.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'MOM #${widget.meetingId}'),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(defaultPadding),
      children: [
        Text(
          loremIpsumText.substring(0, 100),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(
          height: defaultPadding / 2,
        ),
        Text(
          'Held on ${widget.meetingId} Feb, 2023',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: textColorLight),
        ),
        const SizedBox(height: defaultPadding),
        Text(
          loremIpsumText,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: textColorLight),
        ),
        const SizedBox(height: defaultPadding),
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
              onTap: () {},
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
      ],
    );
  }
}
