import 'package:flutter/material.dart';

import '../../util/colors.dart';
import '../../util/theme.dart';

class NoticeRows extends StatelessWidget {
  const NoticeRows({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.shield,
          size: 15,
          color: hintColor,
        ),
        const SizedBox(
          width: defaultPadding / 2,
        ),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        )
      ],
    );
  }
}
