import 'package:flutter/material.dart';

import '../util/theme.dart';

class Heading extends StatelessWidget {
  final String title;
  Heading({Key? key, required this.title, this.overrideFontSize})
      : super(key: key);
  double? overrideFontSize;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .displayLarge
            ?.copyWith(fontSize: overrideFontSize ?? 30),
      ),
    );
  }
}
