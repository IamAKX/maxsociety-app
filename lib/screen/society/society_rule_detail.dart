import 'package:flutter/material.dart';
import 'package:maxsociety/util/colors.dart';
import 'package:maxsociety/util/messages.dart';
import 'package:maxsociety/util/theme.dart';
import 'package:maxsociety/widget/heading.dart';

class SocietyRuleDetailsScreen extends StatefulWidget {
  const SocietyRuleDetailsScreen({super.key, required this.ruleId});
  static const String routePath = '/societyRuleDetailsScreen';
  final int ruleId;

  @override
  State<SocietyRuleDetailsScreen> createState() =>
      _SocietyRuleDetailsScreenState();
}

class _SocietyRuleDetailsScreenState extends State<SocietyRuleDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading(title: 'Rule #${widget.ruleId}'),
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
          'Effected from ${widget.ruleId} Feb, 2023',
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
        const SizedBox(height: defaultPadding / 2),
        Text(
          'Order by,\nMax Society Committee',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: textColorDark),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
